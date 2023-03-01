# Instructions for Participants using AWS CloudFormation

## Overview
To simplify the complex process of configuring participant servers, we offer a solution where participants can automatically deploy the required cloud environment through scripts using AWS CloudFormation. Participants can follow the steps below to generate the contribution file.

## Setp 1. Creation of Cloud Resources for Participants

### 1. AWS Account Creation
Before proceeding, you will need to have an AWS account. Here are the steps to[ create and activate an AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/).

### 2. Create Key Pair
Additionally, you will need a public-private key pair for logging into the EC2 instance. If you don't already have one, you can create a key pair in the [Create a key pair](https://ap-southeast-1.console.aws.amazon.com/ec2/home?region=ap-southeast-1#CreateKeyPair) section. 

Please also download the pem format private key file into your local machine for further use. 
If the downloaded file extension is cer, please manually [rename it to pem](https://stackoverflow.com/questions/23225112/amazon-aws-ec2-getting-a-cer-file-instead-of-pem).

![](https://i.imgur.com/ulGOhWc.gif)


### 3. Create Environment Through CloudFormation
Click on [Contributor AWS Stack](https://ap-southeast-1.console.aws.amazon.com/cloudformation/home?region=ap-southeast-1#/stacks/quickcreate?templateURL=https://s3-trusted-setup-contributor.s3.ap-southeast-1.amazonaws.com/contributor-stack.yaml&stackName=contributor-stack) to create the entire environment. It will prompt you to select a key pair that you created in previous step for logging into the server. Then click 'Create stack' button.
![](https://i.imgur.com/fJrxo6A.gif)

### 4. Confirm Creation Result
After waiting for the CloudFormation stack creation to complete, you can view the newly created server in the [EC2 Instances](https://ap-southeast-1.console.aws.amazon.com/ec2/home?region=ap-southeast-1#Instances:instanceState=running) section.
![](https://i.imgur.com/pA0OwIS.gif)


## Step2. Excute To Generate Contribution File

### 1. Copy the IPv4 Public IP of EC2
Click on the "EC2" service, and then click on "Instances" in the left sidebar. Select the newly created EC2 instance from the list of instances.

In the "Description" tab, you can find the "IPv4 Public IP" field and copy it.
![](https://i.imgur.com/ILKNkSA.gif)

### 2. Log In EC2 Server Using Key Pair

Log in to the EC2 instance using the key pair, follow these steps:

* Open a terminal window on your local machine.
* Change the permissions of the private key file to 400 using the following command: 
  `chmod 400 /path/to/private-key.pem`
* Connect to the EC2 instance using SSH and the private key file. The command should be in the following format: 
`ssh -i /path/to/private-key.pem ubuntu@<public-ip-address>`
* Replace `/path/to/private-key.pem` with the path to the private key file on your local machine, and `<public-ip-address>` with the IPv4 Public IP address of the EC2 instance that you copied earlier.
* If prompted, type "yes" to confirm that you want to connect to the EC2 instance. You are now logged in to the EC2 instance and can proceed with generating the contribution file.

![](https://i.imgur.com/LYv34lx.gif)

### 3. Run Command To Generate Contribution File

Enter the following commands:

`sudo python3 /opt/participant_scripts/make_contribution_file.py`

After the script starts, you will be required to enter the following 4 parameters:

1. \<Sequence Number> 

Prior to executing the computation operations, all participant should be aware of their participant sequence number. For instance, the value of this parameter is 2 for the second participant.

2. \<Hash value from the previous contribution file>

Each time a participant completes the computation of the signature, the signed_attestation.txt content are send to Keybase group. The value of the second parameter hash value is located after the keyword "Your contribution has SHA256 hash".

3. \<Random Text>

This is a random text determined by each participant. You may refer below for combination references.
> Examples of entropy sources
> 1. /dev/urandom from one or more devices
> 2. The most recent Bitcoin block hash
> 3. Randomly mashing keys on the keyboard
> 4. Asking random people on the street for numbers
> 5. Geiger readings of radioactive material. e.g. a radioactive object, which can be anything from a banana to a Chernobyl fragment.
> 6. Environmental data (e.g. the weather, seismic activity, or readings from the sun)

4. \<SFTP Key>
The SFTP private key file can be retrieved from the coordinator via Keybase.

The script then starts a container and completes the generation of the contribution file in the background. 
![](https://i.imgur.com/2YSc0kY.gif)

#### Check Execution Log
    
The estimated duration to excute the Docker run command is approximately 14 hours. To avoid computation failure due to remote disconnection, the process will run in the background.
    
The logs can be viewed by:

1. Use this command to check the script log to trace the stage of execution
```console
sudo tail -f /opt/trustmount/trusted-setup.log
```

2. Completed logs

The computation is successfully completed when the last line of the script log is displayed as follows:
> Step 5 : Upload contribution file success, please fill in the information into your attestation.txt


### Step3: Edit & Refine Content of attestation.txt

After the completion of the computation, participants can refine the keywords in the `/opt/trustmount/attestation.txt` file according to their environment.

The contents before the "Don't modify anything from this point on!!!" phrase should be populated and adjusted by each participant.



 ```
Attestation to contribution <NNNN>  #Replace NNNN with the actual participant sequence number. For example, the value will be 0002 for the second participant.
================================


PLEASE UPDATE THIS SECTION WHERE NEEDED (EVERYTHING BETWEEN <>)
 
**Name:**
<berg jefferson>  #keybase Username
 
**Date:**
<28 June 2022> #Execution omputation date by participant
 
**Location:**
<Singapore>  #Location where participant executed computation
 
**Device:**
<AWS r5a.2xlarge 500GB Disk- Ubuntu 20.04 LTS>  #Participant's computation environment
 
**Entropy sources:**
<Key mashing, bitcoin hashes>  #Random text source
 
**Side channel defences:**
<None>
 
**Postprocessing:**

<
 I added my contribution details to `attestion.txt`
 I signed my contribution using keybase
 I uploaded `loopring_mpc_NNNN.zip` to the server.
 I rebooted my machine.
>
 
**Misc notes:**
 <None>
     
 !!!Don't modify anything from this point on!!!
 - ---------------------------------------------- 
 ...
 ...
```


### Step4: Signing of attestation.txt file
How to operate on a Mac device

1. Initialize the Keybase application with a registered account
2. Copy the text content of the above modified attestation.txt to the Mac deivce
3. Open a terminal, execute the signature command in the directory that attestation.txt file is located

```console
keybase pgp sign --clearsign -i attestation.txt -o signed_attestation.txt
```

> If "ERROR No secret key available" is displayed，please refer to [tutorial](https://docs.crp.to/importpgp.html#generating-keys-keybase) to add PGP key

4. Send the contents of signed_attestation.txt file to the Keybase group，where the hash value wll be used by as a parameter input by subsequent participant.
5. The process is completed. The coodinator will next verify all output results from all participants. If the verification is sucessful, no more further actions will be required.
