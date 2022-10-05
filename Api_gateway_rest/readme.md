Export Environment=test
Export Project=swp-vgi-il-2
Export VPC=
Export VpcBlock=
Export SubnetList=subnet-b4eeb2d2,subnet-f3eac5bb,subnet-58a03902


aws cloudformation deploy \
        --capabilities CAPABILITY_NAMED_IAM \
        --stack-name $Project-$Environment-api-rest-proxy \
        --template-file 29_api-layer-api-gateway-private-config.yml \
        --parameter-override Env=$Environment \
        VPC=$VPC VpcBlock=$VpcBlock \
        SubnetList=$SubnetList
