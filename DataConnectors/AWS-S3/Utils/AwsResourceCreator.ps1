function New-ArnRole
{
    Write-Output `n`n'Arn role definition'
    Set-RetryAction({
        $script:roleName = Read-Host 'Please enter Role name. If you have already configured an Assume Role for Azure Sentinel in the past, please type the name'
        aws iam get-role --role-name $roleName 2>&1| Out-Null
        $isRuleNotExist = $lastexitcode -ne 0
        if ($isRuleNotExist)
        {
            
            $workspaceId = Read-Host 'Please enter Workspace Id (External Id)'
            $rolePolicy = Get-RoleArnPolicy
            $tempForOutput = aws iam create-role --role-name $roleName --assume-role-policy-document $rolePolicy 2>&1
            if ($lastexitcode -eq 0)
            {
                Write-Host  "${roleName} Role created successfully"
            }
        }
    })
}

function New-S3Bucket
{
    Write-Output `n`n'S3 bucket definition.'
    Set-RetryAction({
        $script:bucketName = Read-Host 'Please enter S3 bucket name'
        $headBucketOutput = aws s3api head-bucket --bucket $bucketName 2>&1
        $isBucketNotExist = $null -ne $headBucketOutput
        if ($isBucketNotExist)
        {
            $bucketRegion = Read-Host 'Please enter bucket region'
            if($bucketRegion -eq "us-east-1") # see aws doc https://docs.aws.amazon.com/cli/latest/reference/s3api/create-bucket.html
            {
                $tempForOutput = aws s3api create-bucket --bucket $bucketName 2>&1
            }
            else
            {
                $tempForOutput = aws s3api create-bucket --bucket $bucketName --create-bucket-configuration LocationConstraint=$bucketRegion 2>&1
            }
            
            if ($lastexitcode -eq 0)
            {
                Write-Host  "${bucketName} Bucket created successfully"
            }
        }
    })
    $callerAccount = (aws sts get-caller-identity | ConvertFrom-Json).Account
}

function New-SQSQueue
{
    Write-Output `n'Creating SQS queue'
    Set-RetryAction({
        $script:sqsName = Read-Host 'Please enter Sqs Name'
        $tempForOutput = aws sqs create-queue --queue-name $sqsName 2>&1
    })
}

function Enable-S3EventNotification 
{
    param(
        [Parameter(Mandatory=$true)][string]$DefaultEvenNotificationPrefix
        )
    Write-Output `n'Enabling S3 event notifications (for *.gz file)'
    
    Set-RetryAction({
        $eventNotificationName = Read-Host 'Please enter the event notifications name'
        $eventNotificationPrefix = $DefaultEvenNotificationPrefix
        $prefixOverrideConfirm = Read-Host "The default prefix is '${eventNotificationPrefix}'. `nDo you want to override the event notification prefix? [y/n](n by default)"
        if ($prefixOverrideConfirm -eq 'y')
        {
            $eventNotificationPrefix = Read-Host 'Please enter the event notifications prefix'
        }
        $newEventConfig = Get-SqsEventNotificationConfig
        $existingEventConfig = aws s3api get-bucket-notification-configuration --bucket $bucketName
        if ($null -ne $existingEventConfig)
        {
            $newEventConfigObject = $newEventConfig | ConvertFrom-Json
            $existingEventConfigObject = $existingEventConfig | ConvertFrom-Json 
            
            $newEventConfigObject.QueueConfigurations += $existingEventConfigObject.QueueConfigurations
            $updatedEventConfigs = ($newEventConfigObject | ConvertTo-Json -Depth 6 ).Replace('"','\"')
        }
        else
        {
            $updatedEventConfigs = $newEventConfig.Replace('"','\"')
        }
        $tempForOutput = aws s3api put-bucket-notification-configuration --bucket $bucketName --notification-configuration $updatedEventConfigs 2>&1
    })
}

function New-KMS
{
    Write-Output `n`n'Kms Definition.'
    Set-RetryAction({
        $script:kmaAliasName = Read-Host 'Please enter KMS alias name'
        $script:kmsKeyDescription = aws kms describe-key --key-id alias/$kmaAliasName 2>&1
        $isKmsNotExist = $lastexitcode -ne 0
        if ($isKmsNotExist)
        {
            $script:kmsKeyDescription = aws kms create-key
            $kmsKeyId = ($script:kmsKeyDescription | ConvertFrom-Json).KeyMetadata.KeyId
            $tempForOutput = aws kms create-alias --alias-name alias/$kmaAliasName --target-key-id $kmsKeyId 2>&1
            if ($lastexitcode -eq 0)
            {
                Write-Host  "${kmaAliasName} Kms created successfully"
            }
        }
    })
}