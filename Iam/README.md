aws cloudformation deploy \
        --capabilities CAPABILITY_NAMED_IAM \
        --stack-name snsfanout \
        --template-file iam.yaml

