import boto3

# Connect to EC2 client
ec2 = boto3.client("ec2")

# Start an EC2 instance
response = ec2.start_instances(
	    InstanceIds=[
        'i-0ba41f419b12858fx',
    ],
)
