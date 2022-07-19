aws cloudformation validate-template --template-body file://iam.yaml


aws cloudformation deploy \
        --capabilities CAPABILITY_NAMED_IAM \
        --stack-name iamuser \
        --template-file iam.yaml

