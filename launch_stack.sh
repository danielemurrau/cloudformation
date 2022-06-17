aws cloudformation deploy \
	--capabilities CAPABILITY_NAMED_IAM \
	--stack-name snsfanout \
	--template-file sns.yaml \
     --parameter-override myHttpEndpoint="https://webhook.site/c6e53df7-211f-4310-9eec-7a3bb6d96fe2"
