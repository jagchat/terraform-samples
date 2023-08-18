# Quick Notes

This is just a test a project for EC2.  The script creates an EC2 instance with full access to S3.

used following to create SSH keys (in current folder):

```
ssh-keygen -f ./.ssh/id_rsa
```

NOTE: Ensure access is allowed for SSH connections through security group

```
terraform init
terraform apply
```

- Using AWS console, get the public IP of EC2 instance.
- Use following command to login to EC2 instance remotely.

```
ssh -i ./.ssh/id_rsa ec2-user@<your-ec2-public-ip>
```

#### install node

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
. ~/.nvm/nvm.sh
nvm install --lts
nvm install 16
node -e "console.log('Running Node.js ' + process.version)"
```

#### test a node js sample

- connect to ec2 using SSH
- upload `nodejs-sample-access-s3` to `/home/ec2-user`

```
cd nodejs-sample-access-s3
npm install
node index.mjs
```

The above should list out all S3 buckets.  We don't need any configuration for the script as it interprets the permissions from the role associated with the ec2 instance.
