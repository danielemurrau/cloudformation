https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html

Scripts entered as user data are run as the root user, so do not use the sudo command in the script. Remember that any files you create will be owned by root;

#log of userdata script output can be found in:
/var/log/cloud-init-output.log

By default user data script runs only at first launch of the instance.

If running script ai every reboot is needed then this proceudre can be followed:

https://aws.amazon.com/premiumsupport/knowledge-center/execute-user-data-ec2/

