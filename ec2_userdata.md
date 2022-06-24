https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html

Scripts entered as user data are run as the root user, so do not use the sudo command in the script. Remember that any files you create will be owned by root;

#log of userdata script output can be found in:
/var/log/cloud-init-output.log

