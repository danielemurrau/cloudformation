
1. simple lambda 

export Project=dmitp
export Env=dev
export AWS_REGION=eu-central-1

aws cloudformation deploy \
        --capabilities CAPABILITY_NAMED_IAM \
        --stack-name $Env-$Project-simple-lamda \
        --template-file simple_lambda.yaml 


2. s3 lambda

export Project=dmitp
export Env=dev
export AWS_REGION=eu-central-1
export BucketName=image-bucket

aws cloudformation deploy \
        --capabilities CAPABILITY_NAMED_IAM \
        --stack-name $Env-$Project-s3-lamda \
        --template-file s3_event_lambda.yaml \
        --parameter-override BucketName=$Env-$Project-$BucketName



 Description: Upload an object to an S3 bucket, triggering a Lambda event, returning the object key as a Stack Output.
Parameters:
  Key:
    Description: S3 Object key
    Type: String
    Default: test
  Body:
    Description: S3 Object body content
    Type: String
    Default: TEST CONTENT
  BucketName:
    Description: S3 Bucket name
    Type: String
Resources:
  Bucket:
    Type: AWS::S3::Bucket
    DependsOn: BucketPermission
    Properties:
      BucketName: !Ref BucketName
      NotificationConfiguration:
        LambdaConfigurations:
        - Event: 's3:ObjectCreated:*'
          Function: !GetAtt BucketWatcher.Arn
  BucketPermission:
    Type: AWS::Lambda::Permission
    Properties:
      Action: 'lambda:InvokeFunction'
      FunctionName: !Ref BucketWatcher
      Principal: s3.amazonaws.com
      SourceAccount: !Ref "AWS::AccountId"
      SourceArn: !Sub "arn:aws:s3:::${BucketName}"
  BucketWatcher:
    Type: AWS::Lambda::Function
    Properties:
      Description: Sends a Wait Condition signal to Handle when invoked
      Handler: index.handler
      Role: !GetAtt LambdaExecutionRole.Arn
      Code:
        ZipFile: !Sub |
          exports.handler = function(event, context) {
            console.log("Request received:\n", JSON.stringify(event));
            var responseBody = JSON.stringify({
              "Status" : "SUCCESS",
              "UniqueId" : "Key",
              "Data" : event.Records[0].s3.object.key,
              "Reason" : ""
            });
            var https = require("https");
            var url = require("url");
            var parsedUrl = url.parse('${Handle}');
            var options = {
                hostname: parsedUrl.hostname,
                port: 443,
                path: parsedUrl.path,
                method: "PUT",
                headers: {
                    "content-type": "",
                    "content-length": responseBody.length
                }
            };
            var request = https.request(options, function(response) {
                console.log("Status code: " + response.statusCode);
                console.log("Status message: " + response.statusMessage);
                context.done();
            });
            request.on("error", function(error) {
                console.log("send(..) failed executing https.request(..): " + error);
                context.done();
            });
            request.write(responseBody);
            request.end();
          };
      Timeout: 30
      Runtime: nodejs4.3
  Handle:
    Type: AWS::CloudFormation::WaitConditionHandle
  Wait:
    Type: AWS::CloudFormation::WaitCondition
    Properties:
      Handle: !Ref Handle
      Timeout: 300
  S3Object:
    Type: Custom::S3Object
    Properties:
      ServiceToken: !GetAtt S3ObjectFunction.Arn
      Bucket: !Ref Bucket
      Key: !Ref Key
      Body: !Ref Body
  S3ObjectFunction:
    Type: AWS::Lambda::Function
    Properties:
      Description: S3 Object Custom Resource
      Handler: index.handler
      Role: !GetAtt LambdaExecutionRole.Arn
      Code:
        ZipFile: !Sub |
          var response = require('cfn-response');
          var AWS = require('aws-sdk');
          var s3 = new AWS.S3();
          exports.handler = function(event, context) {
            console.log("Request received:\n", JSON.stringify(event));
            var responseData = {};
            if (event.RequestType == 'Create') {
              var params = {
                Bucket: event.ResourceProperties.Bucket,
                Key: event.ResourceProperties.Key,
                Body: event.ResourceProperties.Body
              };
              s3.putObject(params).promise().then(function(data) {
                response.send(event, context, response.SUCCESS, responseData);
              }).catch(function(err) {
                console.log(JSON.stringify(err));
                response.send(event, context, response.FAILED, responseData);
              });
            } else if (event.RequestType == 'Delete') {
              var deleteParams = {
                Bucket: event.ResourceProperties.Bucket,
                Key: event.ResourceProperties.Key
              };
              s3.deleteObject(deleteParams).promise().then(function(data) {
                response.send(event, context, response.SUCCESS, responseData);
              }).catch(function(err) {
                console.log(JSON.stringify(err));
                response.send(event, context, response.FAILED, responseData);
              });
            } else {
              response.send(event, context, response.SUCCESS, responseData);
            }
          };
      Timeout: 30
      Runtime: nodejs4.3
  LambdaExecutionRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
        - Effect: Allow
          Principal: {Service: [lambda.amazonaws.com]}
          Action: ['sts:AssumeRole']
      Path: /
      ManagedPolicyArns:
      - "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
      Policies:
      - PolicyName: S3Policy
        PolicyDocument:
          Version: '2012-10-17'
          Statement:
            - Effect: Allow
              Action:
                - 's3:PutObject'
                - 'S3:DeleteObject'
              Resource: !Sub "arn:aws:s3:::${BucketName}/${Key}"
Outputs:
  Result:
    Value: !GetAtt Wait.Data