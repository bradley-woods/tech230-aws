import boto3

# Connect to EC2 client
ec2 = boto3.client("ec2")

# Stop an EC2 instance
response = ec2.stop_instances(
	    InstanceIds=[
        'i-0ba41f419b12858fx',
    ],
)
