# secrets
Protecting secrets (passwords, private keys, API keys, app secrets) is important & very easy to mess up (I'm sure I'm not the only person who has pushed a secret into git).
This content is focused primarily on storage of secrets, but we'll touch on some related topics.

**tldr;**
- Do not store secrets (passwords, keys, etc) in git
- Use long passwords
- Hash passwords (argon2, bcrypt)
- Encrypt secrets, like PDF of contract (AES-256)
- AWS has tools for storing secrets

**Requirements**  
- aws
- jq
- sops
- python

## Working with Secrets
Before we jump into the details of secrets, we should review some fundamentals. It's important to understand
the different between [hashing & encrypting](https://stackoverflow.com/questions/4948322/fundamental-difference-between-hashing-and-encryption-algorithms) and when to use one over the other. (Hashing is one way, you can't reverse, whereas encryption can be "reversed")

### Passwords & Randomness
Some quick tips for generating randomness for secrets & general password tips.

- Password length has the biggest impact on cracking duration
- Password length must be at least 10 characters long
- Don't use generated UUIDs for randomness
- If you are not on real hardware, randomness is ... less random
  - `apt-get install rng-tools` helps generate randomness

```bash
# If you are on real hardware ... use openssl
alias gen-secret='openssl rand -base64 32'

# Or you can use pwgen
alias gen-secret='pwgen -n -y 32 -n 1'

# ... or keep it simple
alias gen-secret='export LC_ALL=C; cat /dev/urandom | tr -dc "[:print:]" | fold -w 32 | head -n1'
```
- https://littlemaninmyhead.wordpress.com/2015/11/22/cautionary-note-uuids-should-generally-not-be-used-for-authentication-tokens/
- https://crambler.com/password-security-why-secure-passwords-need-length-over-complexity/
- https://www.betterbuys.com/estimating-password-cracking-times/
- https://www.troyhunt.com/how-long-is-long-enough-minimum-password-lengths-by-the-worlds-top-sites/
- https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/Authentication_Cheat_Sheet.md
- https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/Cryptographic_Storage_Cheat_Sheet.md
- https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/Key_Management_Cheat_Sheet.md


### Hashing
For any content you don't need to store or show the original plain text content later such as passwords.

- Use for storing passwords
  - Use Argon2 or bcrypt for passwords
- Use for checking if a file has been corrupted
- With some hashing algorithms you can craft hash collisions
  - [SHA1 collisions](https://shattered.io/)
  - [MD5 collisions](https://github.com/brimstone/fastcoll)



#### Aside
> What's key is that a cryptographic hashing algorithm is supposed to be resistant against a range of collision attacks. Some hashing algorithms have been mathematically attacked to make it easier for an attacker to generate collisions than it's supposed to be. MD5 is catastrophically broken, do not use it. SHA1 is showing signs of weakness. Don't panic. Make your way calmly to the exit and transition to a stronger hashing algorithm, such as SHA256. <br />- Justin

```python
"""
A basic example of using argon2 in python
pip install passlib
"""
from passlib.hash import argon2

def password_hash(password, rounds=4):
    return argon2.using(rounds=rounds).hash(password)

def password_verify(password, hash):
    return argon2.verify(password, hashed)

hashed = password_hash(password)

if password_verify(password, hashed):
    print("Password is a match")
```
- https://crackstation.net/hashing-security.htm


### Encryption
For content that needs to be "secured" at rest but needs to be accessed later in it's original form. 
An access token for another API is a good example of a string that should be encrypted at rest and then
decrypted when it's going to be used.

- Store encryption keys in a location separate from encrypted content
- Use AES-256-CBC with a high entropy key
  - A reference of a [good implementation in PHP](https://github.com/illuminate/encryption/blob/master/Encrypter.php)
  - `npm install aes-js` [aes-js](https://www.npmjs.com/package/aes-js)
  - `pip install pycrypto`


```python
"""
A basic example of AES in python
pip install pycrypto
"""
from Crypto.Cipher import AES
from Crypto import Random

key = 's6VsWRuQ1OWERkg3rqWVIa21UphBM2p1PMypCjpWBppIgYeK0H/0B6Bd0y2qAHvlFPsfxA+V1x8JsG0+nihVhA=='
iv = Random.new().read(AES.block_size)

# Setup object for encryption ....
aes = AES.new(key, AES.MODE_CBC, iv)
ciphered = aes.encrypt("Secret secrets are no fun, Secret secrets hurt someone.")

# Decrypt the value, creating a new object for demo purposes 'proofing'
# but you could reuse the `aes` object
aes = AES.new(key, AES.MODE_CBC, iv)
plain = aes.decrypt(ciphered)
print(plain)
```



## AWS Services
### KMS
Any service in AWS using encryption generally interacts with KMS for encrypting content. You can say it is a foundational service in AWS for working with encryption. You can use the 
encryption features of KMS directly.

- https://gist.github.com/hassy/96256cfde707fed40714c02b64f8049e
- https://cloudonaut.io/encrypting-sensitive-data-stored-on-s3/
- https://aws.amazon.com/kms/
- https://github.com/mozilla/sops

```sh
# Generate random text with kms
aws kms generate-random --number-of-bytes 64 --query Plaintext --output text

# List encryption key ids
aws kms list-keys

# Get the details for all the keys
aws kms list-keys --query 'Keys[].KeyId' --output text \
    | xargs -n1 -I{} aws kms describe-key --key-id {}

# Create a key for encryption
aws kms create-key \
    --description 'SECRETS - For encryption of app secrets' \
    --key-usage ENCRYPT_DECRYPT \
    --origin AWS_KMS

# List only keys that are not AWS managed
aws kms list-keys --query 'Keys[].KeyId' --output text \
    | xargs -n1 -I{} aws kms describe-key --key-id {} --query 'KeyMetadata' \
    | jq 'select(.KeyManager == "CUSTOMER")'

# Example of encrypting file contents with KMS
export KMS_KEY_ID=7a269a17-bb23-4699-929b-62f930ae4c76
aws kms encrypt \
    --key-id "${KMS_KEY_ID}" \
    --plaintext "fileb://secret.txt" \
    --query CiphertextBlob --output text \
    | base64 --decode > secret_kms.txt

# ... and then later decrypting the contents
aws kms decrypt \
    --ciphertext-blob fileb://secret_kms.txt \
    --output text --query Plaintext \
    | base64 --decode
```


##### IAM
```json
{
  "Sid": "Allow use of the key",
  "Effect": "Allow",
  "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
  ],
  "Resource": "*",
  "Principal": {
        "AWS": [
          "arn:aws:iam::927034868273:role/sops-dev-xyz"
        ]
  }
}

```

#### Example
In your application you can leverage KMS to handle encryption, so you don't have to 
worry about storing encryption keys or anything fun like that.

```python
""" 
Example of using KMS for encryption
taken from https://boyter.org/2017/12/simply-encrypt-string-boto3-python-aws-kms/
"""
import base64
import boto3

class Encryptor(object):
    def __init__(self, session, alias="yourapp"):
        self.session = session
        self.alias = alias
        self.client = self.session.client('kms')

    def encrypt(self, secret):
        ciphertext = self.client.encrypt(
            KeyId=alias,
            Plaintext=bytes(secret),
        )
        return base64.b64encode(ciphertext["CiphertextBlob"])

    def decrypt(self, ciphered):
        plaintext = self.client.decrypt(
            CiphertextBlob=bytes(base64.b64decode(secret))
        )
        return plaintext["Plaintext"]
    
    @classmethod
    def create(cls):
        return cls(boto3.session.Session())

enc = Encryptor.create()
ciphered = enc.encrypt("YOU DIDN'T SAY THE MAGIC WORD")
plain = enc.decrypt(ciphered)
print(plain)
```

- https://medium.com/devopslinks/introduction-to-aws-kms-e87fffbf55f


#### SOPS
Since we are on the topic of KMS, I wanted to touch on a tool that uses KMS for working with secrets.
Sops is a tool for encrypting content with a number of engines (AWS KMS, GCP KMS, Azure Key Vault and PGP). If you aren't using AWS services (EC2,ECS,lambda) it's easy to use (& cheap) KMS 
with sops to handle secrets encryption. You can store the encrypted file in version control
and then once the secret is deployed you can decrypt it with sops and your app can consume it.

```bash
# If you download and install sops you can use it with KMS for encryption
export SOPS_ARN=arn:aws:kms:us-west-1:141084547154:key/82ad3c24-e719-4931-5a34-860d4e1b0cb3

# With sops it will open an editor (vim) which you create the config in 
# {"db_password":"RandomPassword", "github_token":"tokentokentoken"}
sops --kms "${SOPS_ARN}" secrets.json

# After created the encrypted config you can see the output
cat secrets.json
```
```json
{
	"db_password": "ENC[AES256_GCM,data:9XZBTrl55Vrqq/uUlFw=,iv:BT04Hx2GQGt7RgA5hi8GTQURcLErPCXcMzUuxj0j7ao=,tag:rSYOrVUgBBUQ1nZ+z5xr/A==,type:str]",
	"github_token": "ENC[AES256_GCM,data:dEa0Q1lH6sl5rU5n52EF,iv:G+vgYEeri0pJ6sdWU7dQ3yRywF1jBhR6n4gYMkJNi4I=,tag:uFMiY1lFQqfbSn4XcDepbg==,type:str]",
	"sops": {
		"kms": [
			{
				"arn": "arn:aws:kms:us-west-1:141084547154:key/53ad3c24-e719-4931-9a34-860d4e1b0ca3",
				"created_at": "2019-03-27T16:53:11Z",
				"enc": "AQICAHiY5gXGwT7jofYpW5bIMvnVCX3dktV5u6XtJwier3mm0gF13RxvA6UJyxd439ZAREF0AAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMZX2r8uQhSlSLGb4qAgEQgDuS/bUwR/qjaBqb3EGuqZ6pDzQUe8aMgGUsHaK6YbyBUCZ4tWQAANRhi1pY4jQWFyFfJygU6IaYMArybw=="
			}
		],
		"gcp_kms": null,
		"azure_kv": null,
		"lastmodified": "2019-03-27T16:58:15Z",
		"mac": "ENC[AES256_GCM,data:2YWitW69pqR4ccpUa5E+08vZskHYdVY9pPu4/UccbFV8Y2RPqq5gcET8va/Avpic0zhlNaYatHzRXUOrKeOSLzmXyCGpr9PCTh2m0WDgucbFIF0Fu8RrB8Ou2HMHFaPkAq4F0LueaDgNiboEyIypi8+GSH0JxPq6T4FpqFDuNYE=,iv:ltZ/mlBYiOg97ddNfvm4N3o7KSToruBckHn7oQ7qJbw=,tag:H81MyccCoa5ek0Eojg8bwQ==,type:str]",
		"pgp": null,
		"unencrypted_suffix": "_unencrypted",
		"version": "3.2.0"
	}
}
```

```bash
# ... then once you have the secrets deployed, you can decrypt them for your app to consume
sops --decrypt secrets.json > config.json
```


### AWS Secrets Manager
- https://aws.amazon.com/secrets-manager/
- https://aws.amazon.com/secrets-manager/pricing/

##### Features
- Automatic rotation using lambdas
- Specify KMS encryption keys
- Deleted secrets can be queued for delete in 7-30 days
- Size limitations of 4096 chars
- Secrets can be shared across AWS accounts

```sh
# If you are on a VM, you can use secrets manager to generate a password
alias gen-secret='aws secretsmanager get-random-password --password-length 32 --require-each-included-type --exclude-characters '"'@/\"'"' | jq -r ".RandomPassword"'
```


##### Usage
```sh
# Generate a random password
aws secretsmanager get-random-password \
    --password-length 20 \
    --require-each-included-type \
    --exclude-characters '@/"' \
    --query RandomPassword --output text

# Create a secret in AWS 
aws secretsmanager create-secret --name test \
    --secret-string '{"db_pass":"ALongerPassword1sBetter","db_user":"dbuser_0053433","app_secret":"7184e93f8d81c43440aaf1ed37f4772b08ba88e4"}' \
    --tags '[{"Key":"service","Value":"api-users"},{"Key":"owner","Value":"jdoe"}]'

# or source secrets from a JSON file which should be immediately killed
aws secretsmanager create-secret --name test \
    --secret-string file://secrets_api.json \
    --tags '[{"Key":"service","Value":"api-users"},{"Key":"owner","Value":"jdoe"}]' && rm secrets_api.json

# View secret json formatted
aws secretsmanager get-secret-value \
    --secret-id test --query SecretString --output text | jq '.'

# Convert secret json to dotenv format
aws secretsmanager get-secret-value \
    --secret-id test \
    | jq -r '.SecretString | fromjson | to_entries[] | (.key|ascii_upcase) + "=" + (.value|tostring)'

# Update the value of a specific key
aws secretsmanager put-secret-value \
    --secret-id test \
    --secret-string $(aws secretsmanager get-secret-value --secret-id test | jq -r '.SecretString | fromjson | .db_user="c91d4cd58f00b201" | tostring')

# Delete a secret with a recovery window
aws secretsmanager delete-secret \
    --secret-id testv \
    --recovery-window-in-days 7

# Delete fo' real
aws secretsmanager delete-secret  \
    --secret-id test \
    --force-delete-without-recovery
```

- https://docs.aws.amazon.com/code-samples/latest/catalog/lambda_functions-secretsmanager-RDSMariaDB-Multiuser.py.html


##### Example
Below is a config of secrets we need & a script we are going to generate the secrets and put 
them into Secrets Manager. The secrets are generated then pushed into Secrets Manager.
Provisioning scripts can later pull those values when creating the database and deploying your
application.

```json
{
    "db_pass": "GENERATE",
    "app_key": "GENERATE",
    "github_token": "SECRET:yourapp/dev/github_token"
}
```

```sh
#!/bin/bash
set -e

function gen-secret()
{   size="${1:-20}"
    aws secretsmanager get-random-password \
        --password-length "${size}" \
        --require-each-included-type \
        --exclude-characters '@/\"' \
        | jq -r ".RandomPassword"
}

formatted=$(cat secret.json)
gen_for_keys=$(jq -r '[to_entries[]  | select (.value == "GENERATE") | .key] | join(" ")' < secret.json)
for key in ${gen_for_keys}
do
    echo "[i] Generating secret for ${key}"
    formatted=$(echo "${formatted}" | jq -r ".${key}=\"$(gen-secret 64)\" | tostring")
done

formatted=$(echo "${formatted}" | jq -r ".github_token=\"$(aws secretsmanager get-secret-value --secret-id github_token | jq -r '.SecretString')\" | tostring")
aws secretsmanager create-secret --name 'yourapp/env/secrets' --secret-string "${formatted}"
```

Then in your application, which will need an IAM policy to read the secrets from that key, you can fetch those secrets and use them to connect to other services.

```python
# https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/secretsmanager.html
import boto3
import json

secrets = boto3.client('secretsmanager').get_secret_value(
    SecretId='yourapp/env/secrets',
).get('SecretString')

if secrets is None:
    raise Exception("No secrets found here ....")

secret = json.loads(secret)
```

#### IAM

For your application to access secrets, it will need to have a role with the policy similar to below.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:DescribeSecret",
                "secretsmanager:GetRandomPassword",
                "secretsmanager:GetSecretValue",
            ],
            "Resource": "arn:aws:secretsmanager:${AWS::Region}:${AWS::AccountId}:secret:yourapp/*"
        }
    ]
}
```

### AWS Systems Manager 
AWS Systems Manager has a parameter store you can use to securely store passwords 


##### Features
- You can version the parameters
- Size limitations of 4096 chars
- Limit of 10,000 parameters per account
- FREE

```sh
# Add a secret to the parameter store
aws ssm put-parameter \
    --name '/yourapp/dev/db/password' \
    --value 'LuckyStr1kesOfThePast' \
    --type SecureString \
    --overwrite

# Get all the parameters with that contain the prefix you expect
aws ssm describe-parameters \
    | jq -r ".Parameters[] | select(.Name | contains(\"/yourapp/dev\")) | .Name"

# Get all parameters decrypted
aws ssm get-parameters \
    --with-decryption \
    --names  $(aws ssm describe-parameters | jq -r ".Parameters[] | select(.Name | contains(\"/yourapp/dev\")) | .Name") \
    | jq -r '.Parameters[]'

# Get parameters in dotenv format
aws ssm get-parameters \
    --with-decryption \
    --names  $(aws ssm describe-parameters | jq -r ".Parameters[] | select(.Name | contains(\"/yourapp/dev\")) | .Name") \
    | jq -r '.Parameters[] | (.Name|ascii_upcase | split("/") | (.[3] + "_" +  .[4]) ) + "=" + (.Value)'

```
- https://hackernoon.com/you-should-use-ssm-parameter-store-over-lambda-env-variables-5197fc6ea45b
- https://medium.com/nordcloud-engineering/ssm-parameter-store-for-keeping-secrets-in-a-structured-way-53a25d48166a
- https://hackernoon.com/a-few-tips-for-storing-secrets-using-aws-parameter-store-f03557c5cf1b

##### IAM
For your application to access parameter store secrets, it will need to have a role with the policy similar to below.
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["ssm:GetParameter*"],
            "Resource": "arn:aws:ssm:${AWS::Region}:${AWS::AccountId}:parameter/yourapp/dev*"
        }
    ]
}
```

```python
# https://aws.amazon.com/blogs/compute/sharing-secrets-with-aws-lambda-using-aws-systems-manager-parameter-store/
import boto3
db_pass = boto3.client('ssm').get_parameters_by_path(
    Path='yourapp/dev/db/password',
    Recursive=False,
    WithDecryption=True).get('Parameters')

if not db_pass:
    raise Exception("No secrets found here ....")

db_pass = db_pass[0].Value
```


### EJSON
*Ignore*
- https://github.com/Shopify/ejson

```sh
# If you have go installed, you can build
GOOS=darwin GOARCH=amd64 go build -o ejson "github.com/Shopify/ejson/cmd/ejson"
# GOOS=linux GOARCH=amd64 go build -o "build/bin/linux-amd64" "github.com/Shopify/ejson/cmd/ejson"
# GOOS=windows GOARCH=amd64 go build -o ejson.exe "github.com/Shopify/ejson/cmd/ejson"

cp ejson ~/bin/ejson
mkdir -p ~/.ejson
export EJSON_KEYDIR=$HOME/.ejson 

# Start off secrets file
printf '{\n  "_public_key":"%s",\n}' "$(ejson -w)" > secrets.ejson

vim secrets.ejson 

# Encrypt the json
ejson e secrets.ejson

# Decrypt the json
ejson d secrets.ejson

# In dotenv format 
ejson d secrets.ejson  | jq -r 'to_entries[] | (.key|ascii_upcase) + "=" + (.value|tostring)' | grep -v _PUBLIC_KEY
```

## TODO
- https://github.com/99designs/aws-vault
- Sharing secrets with other people
- https://epsagon.com/blog/aws-lambda-and-secret-management/
- https://www.1strategy.com/blog/2019/02/28/aws-parameter-store-vs-aws-secrets-manager/
