import boto3

# Connect to EC2 resource
ec2 = boto3.resource("ec2")

# Create an EC2 instance
instance = ec2.create_instances(
    ImageId="ami-0f81b93b199fe620x",
    MinCount=1,
    MaxCount=1,
    InstanceType="t2.micro",
    KeyName="tech230",
    SecurityGroup="sg-030a1321b762c32fx"
)
