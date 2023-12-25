# Extra for Node Ops. 

## Setup CloudWatch Agent on EC2.

### Install gpg (verify deb package)
```bash
sudo apt install gpg

```

### Download and install Agent.
```bash
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

### Config Agent, set json-log path.
```bash
sudo vi /opt/aws/amazon-cloudwatch-agent/bin/config.json

```

* Paste and edit config. 
```json
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

### Gen IAM policy and link user & api_key.
```json
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

### Config aws-cli with api_key.
```bash
aws configure

AWS Access Key ID [None]: <AWS_ID>
AWS Secret Access Key [None]: <AWS_SECRET>
Default region name [None]: ap-northeast-1
Default output format [None]: json

```

### Set Agent credential. 
```bash
sudo tee -a /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml <<EOF
[credentials]
    shared_credential_profile = "default"
    shared_credential_file = "/home/admin/.aws/credentials"
EOF

```

### Fetch agent's config with ctl.
```bash
sudo amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s

```

### Etc. ctl and debugging.
```bash
sudo amazon-cloudwatch-agent-ctl -a start
sudo amazon-cloudwatch-agent-ctl -a stop
sudo amazon-cloudwatch-agent-ctl -a status

less /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log

```


## Deploy Lambda Subscription Filter.

### Create CDK project and setup aws-cli with AWS_SECRET

```bash
mkdir cloudwatch-line-notify
cd cloudwatch-line-notify

cdk init app -l typescript

```

* Set env for aws & [execute cdk stack](https://gist.github.com/ubinix-warun/4eafb6e26d3ed1dc5a42bfec47e48e7f#file-cloudwatch-line-notify-ts).

```typescript
...

new CloudwatchLineNotifyStack(app, 'CloudwatchLineNotifyStack', {

  env: {
     account: '<AWS_ACCOUNT>', 
     region: '<AWS_REGION>' 
  },

});
```

### Link CloudWatch and [SubscriptionFilter](https://gist.github.com/ubinix-warun/4eafb6e26d3ed1dc5a42bfec47e48e7f#file-cloudwatch-line-notify-stack-ts) Lambda fn.

```typescript
...

export class CloudwatchLineNotifyStack extends cdk.Stack {
  public readonly watchFn: lambda.Function;

  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const watchFn = new NodejsFunction(this, 'watchLambda', {
      entry: 'lambda/index.ts',
      handler: 'handler',
      runtime: lambda.Runtime.NODEJS_18_X,
    });
    
    //link an AWS CloudWatch log group for receiving logs
    const logGroup = logs.LogGroup.fromLogGroupArn(this, '<>', 
      '<>');
    ...

    new logs.SubscriptionFilter(this, 'WatchSubscription', {
      logGroup,
      destination: new destinations.LambdaDestination(watchFn),
      filterPattern: logs.FilterPattern.any(
        logs.FilterPattern.stringValue("$.message","=","Successfully produced a new block")
      ),
      filterName: 'ProducedNewBlock',
    }); 
     
  }
}
```

### Handle Log events on [Lambda fn](https://gist.github.com/ubinix-warun/4eafb6e26d3ed1dc5a42bfec47e48e7f#file-index-ts).

```typescript
...

const notify = new Notify({
	token: "<LINE_NOTIFY_TOKEN>"
})

export const handler: CloudWatchLogsHandler = (
    event: CloudWatchLogsEvent,
    _context: Context,
    callback: Callback
  ): void => {
    console.log('EVENT: \n' + JSON.stringify(event, null, 2));
    
    const decoded = Buffer.from(event.awslogs.data, "base64");
    zlib.gunzip(decoded, (e, result) => {
        if (e) {
          callback(e, null);
        } else {
          const json: CloudWatchLogsDecodedData = JSON.parse(
            result.toString("ascii")
          );
          
          json.logEvents.forEach(async (event) => {
            const jsonlog = JSON.parse(event.message);
            console.log("DETAIL: (json log)", JSON.stringify(jsonlog, null, 2));
            
            ...
        
            const consensus_state = jsonlog.metadata.breadcrumb.validated_transition.data.protocol_state.body.consensus_state
            const msg = `${jsonlog.message} - Block height: ${consensus_state.blockchain_length} Epoch: ${consensus_state.epoch_count}`;
            try {
                const resp = await notify.send({
                    message:  msg,
                 });
                console.log(resp);

            } catch (error) {
                console.log(error);

            }

          });

          callback(null);
        }
    });

};
```
