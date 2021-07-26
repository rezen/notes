# AWS

- Install cli tools for happiness
  - `pip install awscli`
  - `pip install aws-shell`
  - `apt-get install jq`
- https://github.com/open-guides/og-aws
- https://medium.com/@kief/https-medium-com-kief-using-pipelines-to-manage-environments-with-infrastructure-as-code-b37285a1cbf5
- http://creately.com/blog/diagrams/aws-templates-for-architecture-diagrams/
- https://www.slideshare.net/AmazonWebServices/masterclass-advanced-security-best-practices
- https://www.nvteh.com/news/problems-with-public-ebs-snapshots


## EC2
- The bread and butter of AWS
- Default into public subnet
- You can run a command across all instances if you have their agent installed
- `UserData` config allows you to provide some instance config or provisioning, which is run under sudo
  - `/var/lib/cloud/instance/scripts/part-001`
  - `ls /var/log/cloud-init-output.log`

### Security Groups
- http://harish11g.blogspot.com/2015/06/best-practices-tips-on-amazon-web-services-security-groups-aws-security-managed-services.html
- http://www.stratoscale.com/blog/compute/aws-security-groups-5-best-practices/


## Elastic Beanstalk
- Think of a Heroku setup, with server setup abstracted away
- Has a cli tool just like Heroku
- You choose your platform, eg PHP. python, node.js etc and go from there
- Orchestrates setting up EC2 instances with load balancing etc
- Sets everything up using dynamic on-the-flow CloudFormation templates

**Links**
- http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/ebextensions.html
- https://github.com/lapygithub/eb_config_examples
- https://medium.com/trisfera/getting-to-know-and-love-aws-elastic-beanstalk-configuration-files-ebextensions-9a4502a26e3c
- http://blog.rudylee.com/2014/05/22/configuring-elastic-beanstalk-environment-with-ebextensions/
- https://tech.pic-collage.com/two-must-have-configurations-when-using-aws-elastic-beanstalk-with-docker-720ce7c5ec91
- https://github.com/awslabs/eb-demo-php-simple-app
- http://blog.flux7.com/blogs/docker/10-steps-deploying-docker-containers-on-elastic-beanstalk
- https://www.slideshare.net/AmazonWebServices/running-microservices-and-docker-on-aws-elastic-beanstalk-august-2016-monthly-webinar-series
- `.elasticbeanstalk/config.yaml`
- `.ebextensions/options.config`
- `.ebextensions/options.config`


## VPC
- Plan out your subnets or plan to fail!
- Is software defined networking

**Links**
- https://www.slideshare.net/gsilverm/aws-vpc-in
- https://medium.com/aws-activate-startup-blog/practical-vpc-design-8412e1a18dcc
- https://charity.wtf/2016/03/23/aws-networking-environments-and-you/
- http://blog.flux7.com/blogs/aws/vpc-best-configuration-practices
- http://cloudacademy.com/blog/aws-vpc-configuration-five-kick-yourself-mistakes/
- https://www.pluralsight.com/blog/it-ops/simplify-routing-how-to-organize-your-network-into-smaller-subnets


#### Subnets
- A VPC has multiple subnets
#### Route Tables
- Routes you associate with your subnet

#### NACLS
- Return/response traffic can come in through a range of ports, make sure to leave that range open
http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Appendix_NACLs.html


## S3
- Buckets of storage yo
- https://www.secplicity.org/2017/10/13/s3-bucket-security-acls-policies/amp/


## CloudWatch
- Detailed monitoring vs regular is more granular interval of recording
- Has alarms and alerting
- https://github.com/jorgebastida/awslogs
- http://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/QuickStartEC2Instance.html
- http://blog.brianbeach.com/2014/09/cloudwatch-logs-push.html
- http://zoltanaltfatter.com/2017/01/13/centralized-logging-with-cloudwatch-logs/
- https://cloudacademy.com/blog/centralized-log-management-with-aws-cloudwatch-part-1-of-3/
- https://alestic.com/2010/12/ec2-user-data-output/
- https://aws.amazon.com/blogs/devops/send-ecs-container-logs-to-cloudwatch-logs-for-centralized-monitoring/

## Route 53
- DNS management
- Can configure health checks to request a specific domain or ip
- Allows you to create complex routing configurations with traffic policies etc

## CloudFormation
Infrastructure as code! You can create yaml|json defintions of your infrastructure stack which creates your 
stack.
- You can get a cost estimate from a CloudFormation template
http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-paying.html
- You can reference other CloudFormation templates for organization sake
- Use `AWS::CloudFormation::Init` for initial setup
- `aws cloudformation validate-template --template-body file:////home//local//test//sampletemplate.json`

**Links**
- https://github.com/toddm92/aws/wiki/CloudFormation-Best-Practices
- http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-paying.html
- https://www.slideshare.net/AmazonWebServices/dvo304-aws-cloudformation-best-practices
- https://www.quora.com/Why-are-there-no-AWS-CloudFormation-success-stories
- https://paperairoplane.net/?p=680
- http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html
- https://blog.engelke.com/2012/12/28/provisioning-a-server-with-cloudformation/

## IAM
### Groups
- Have policies, up to 10 policies per group http://docs.aws.amazon.com/IAM/latest/UserGuide/reference_iam-limits.html
- A user can belong to many groups

### Users
- Can have api only access or console access or both
- Can belong to one or many groups
- Can be assigned specific policies vs policies inherited from group membership

### Policy
- Dictates what you can or can't do
- Inline policies are for one-off special snowflakes and should be avoided generally 

### Roles
- You can assign a role to a service, eg an EC2 instance can have a role of PublicWebServer which has its own policies
- Think of a role as an identity, not a group
- Leverage for cross account access

### KMS
Storing encryption keys in the cloud

- https://blog.fugue.co/2015-04-21-aws-kms-secrets.html
- https://github.com/fugue/credstash
- https://medium.com/@mda590/simple-secrets-management-via-aws-ec2-parameter-store-737477e19450
- https://github.com/mozilla/sops

## AWS Config
- Run a set of checks against resources to ensure adherance to certain standards
- $2 a rule
- https://youtu.be/kErRv4YB_T4
- https://www.youtube.com/watch?v=fBewaclMo2s
- https://jupiterone.com/blog/we-turned-off-aws-config/
- `AWS_REGION=us-west-1 aws configservice describe-config-rules`
- List of AWS managed rules
  - https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html

## CloudTrail
Think of it as the auditd of linux but for AWS

## CodeCommit
- Private git repos which can have triggers!
- http://www.paul-kearney.com/2015/09/migrating-from-github-to-aws-codecommit.html
- If you have an instance role that has access to a repos you need to use the credential helper
    http://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-https-windows.html#setting-up-https-windows-credential-helper
    ```shell
    git config --global credential.helper '!aws codecommit credential-helper $@'
    git config --global credential.UseHttpPath true
    ```


## Security
- http://flaws.cloud/

## Other
- Use Resource GRoups to get a birds eye view of everything, across AZs

### AWS Certificate Mananger
- http://serverfault.com/questions/9708/what-is-a-pem-file-and-how-does-it-differ-from-other-openssl-generated-key-file
- https://docs.aws.amazon.com/acm/latest/userguide/acm-services.html
- http://docs.aws.amazon.com/acm/latest/userguide/import-certificate.html
- https://jamielinux.com/docs/openssl-certificate-authority/certificate-revocation-lists.html
- https://www.schneier.com/academic/paperfiles/paper-pki-ft.txt