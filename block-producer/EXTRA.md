
# Setup CloudWatch Agent

```
sudo apt install gpg

```

```
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb

wget https://s3.amazonaws.com/amazoncloudwatch-agent/assets/amazon-cloudwatch-agent.gpg
wget https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb.sig

gpg --import amazon-cloudwatch-agent.gpg
gpg --fingerprint D58167303B789C72

gpg: Signature made Tue Nov  7 19:54:42 2023 UTC
gpg:                using RSA key D58167303B789C72
gpg: Good signature from "Amazon CloudWatch Agent" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 9376 16F3 450B 7D80 6CBD  9725 D581 6730 3B78 9C72

sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

```

```
sudo vi /opt/aws/amazon-cloudwatch-agent/bin/config.json

{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/mina/.mina-config/mina.log",
            "log_group_name": "mina-node-bp-group",
            "log_stream_name": "mina.log"
          }
        ]
      }
    }
  },
  "metrics": {
    "namespace": "mina-node-bp",
    "metrics_collected": {
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "metrics_collection_interval": 60,
        "resources": [
          "*"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "metrics_collection_interval": 60
      }
    }
  }
}

```

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "cloudwatch:PutMetricData",
                "logs:CreateLogGroup",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
```

```
aws configure

AWS Access Key ID [None]:
AWS Secret Access Key [None]:
Default region name [None]: ap-northeast-1
Default output format [None]: json

```


```
sudo tee -a /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml <<EOF
[credentials]
    shared_credential_profile = "default"
    shared_credential_file = "/home/admin/.aws/credentials"
EOF

```


```
sudo amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s

```


```
sudo amazon-cloudwatch-agent-ctl -a start
sudo amazon-cloudwatch-agent-ctl -a stop
sudo amazon-cloudwatch-agent-ctl -a status

less /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log

```


```

    "logs:CreateLogStream",
    "logs:CreateLogGroup",
    "logs:PutLogEvents",
    "cloudwatch:PutMetricData"

```
