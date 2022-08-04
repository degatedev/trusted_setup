# Instructions for Participants


## Overview
This document outlines Phase 2 of DeGate's trusted setup processes which participants are required to undergo. 

Before the coordinator is able to execute the export key operation, every participant is required to execute server commands to compute the contribution files required for the next participant in the designated sequence.

To simplify the process for participants, the entire computation and file transfer processes are packaged into Docker and SFTP. In most instances, participants are only required to input specified parameters and the script will automatically download the necessary files, perform computation, and upload the new files. 

At any point in time if the participant encounters any form of difficulties during the trusted setup process, please contact the coordinator for assistance.

## Get Ready Before Your Participation

1. Make a [Keybase](https://keybase.io/) account and link it to your twitter or github account so people can be sure it's actually you that participated. Install the [Keybase Desktop Software](https://keybase.io/docs/the_app/install_macos) which will be used to sign the attestation.
1. Using your Keybase software, join a team called [**degateceremony**](https://keybase.io/team/degateceremony), this is the official communication channel, but we'll also collect another IM account of yours to inform you when your turn is coming up.


## Participants Hardware Requirements

In order to contribute in the computation and output signing, participants will need to prepare a Server and a Mac machine.


### Server Specifications
1. **Minimum specifications:** CPU 4 cores / memory 16 GB / disk space 1T
    

2. **Recommended Models**: 
    
    AWS (m5.xlarge) / Azure (D4s_v3) / GCP (e2-standard-4)
3. **Recommended Server Location:** 
  
    Singapore (Same region as SFTP)
4. **Recommended OS:** 
   
    Ubuntu 20.04
    
    
### Create a Swap space

Please create a 200 GB swap space.

```console
# Create a file that will be used for swap
sudo fallocate -l 200G /swapfile 
```
```console
# To set the correct permissions type
sudo chmod 600 /swapfile
```
```console
# Use the mkswap utility to set up the file as Linux swap area
sudo mkswap /swapfile 
```
```console
# Enable the swap 
sudo swapon /swapfile 
```
To verify that the swap is active, use free command as shown below:
```console
sudo free -h 
```
For details, please refer to this [tutorial](https://linuxize.com/post/create-a-linux-swap-file/). 

### Installation of Docker
Install/Start Docker on Ubuntu
```console
sudo apt update && sudo apt install docker.io -y && sudo systemctl enable docker && sudo systemctl start docker
```

## Steps for Participants
Before the commencement of participant operations, the participant sequence number will be notified to each participant via Keybase by the coordinator which is used as the first parameter during execution.

The example below assumes the role of the second participant. Please ensure to replace with the actual participant sequence number before execution.

### Step1: Retrieving & Configuring SFTP Private Key file
1. The SFTP private key file can be retrieved from the participant via Keybase (For the second participant, the file is named sftpuser2.key)
2. Log in the server, create /opt/trustmount directory and set permissions type

```console
sudo mkdir -p /opt/trustmount
sudo chmod 777 -R /opt/trustmount
```

3. Transfer the private key file to the /opt/trustmount/ directory. Upload the private key file from the second participant's local mac to the server. 

For example: Open the terminal on local mac, execute the following command in the directory where the private key file is located to upload the private key file (each participant to replace sftpuser2.key with their designated private key file)
 
 ```console
 scp sftpuser2.key serverusername@serverIP:/opt/trustmount/.
 ```


### Step2: Initiate Container to Perform Computation

#### Execute Docker Commands
Execute the following command in the server. Participants are required to specify 3 parameters and the command will automatically perform the computation operations sequentially.
```console
sudo docker run --name trust -v /opt/trustmount:/opt/trustmount -itd degate/trusted-setup-participants:v1.0.0  <Sequence Number>  <Hash value from the previous contribution file> <Random Text>
```

Parameter Descriptions
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


Example (Participant sequence number is 2)
```console
sudo docker run --name trust -v /opt/trustmount:/opt/trustmount -itd degate/trusted-setup-participants:v1.0.0 2 0x376caae67d3e5e4bf05c1253ed364dcb40502166ec0bc492408b4a96d28f806b As5unTfkCLyXFcFEoWncTWpGwhgZXmfeLcHE
```


#### Check Execution Log
    
The estimated duration to excute the Docker run command is approximately 20 hours. To avoid computation failure due to remote disconnection, the process will run in the background.
    
The logs can be viewed by:

1. Use this command to check the script log to trace the stage of execution
```console
sudo cat /opt/trustmount/trusted-setup.log
```
2. Use this command to check the active container logs
```console
sudo docker logs trust
```

3. Completed logs

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
