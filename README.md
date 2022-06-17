# aws cli
1. Get list of AWS profiles:
aws configure list-profiles

2. Choose profile to use
export AWS_PROFILE=profile_name

3. Check your current profile
aws configure list

4. Set the region where you want to deploy
export AWS_REGION=eu-central-1

5. create stack from command line using the sns.yaml template
aws cloudformation deploy \
        --capabilities CAPABILITY_NAMED_IAM \
        --stack-name snsfanout \
        --template-file sns.yaml \
        --parameter-override myHttpEndpoint="https://webhook.site/c6e53df7-211f-4310-9eec-7a3bb6d96fe2"
