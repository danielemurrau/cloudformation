aws cloudformation estimate-template-cost \
  --template-body file://ec2.yaml \
  --parameters ParameterKey=KeyName,ParameterValue=my_ec2 \
  ParameterKey=InstanceType,ParameterValue=t2.micro
