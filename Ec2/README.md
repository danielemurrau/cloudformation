# aws cli
1. Get list of AWS profiles:
aws configure list-profiles

2. Choose profile to use
export AWS_PROFILE=profile_name
export AWS_PROFILE=dmitp

3. Check your current profile
aws configure list

4. Set the region where you want to deploy
export AWS_REGION=eu-central-1

5. create stack from command line using the sns.yaml template
aws cloudformation deploy \
        --capabilities CAPABILITY_NAMED_IAM \
        --stack-name ec2-code-deploy \
        --template-file ec2.yaml \
        --parameter-override "KeyName=dmitp"