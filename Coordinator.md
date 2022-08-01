# Instructions for Coordinator 
The coordinator role is assigned by DeGate DAO which is responsible for coordinating and verifying that the entire Trusted Setup is correctly executed according to the predetermined processes, and importantly to output the final execution results. 

## Coordinator's Pre-Phase 2 Tasks

### Environment Preparation

#### 1）Operating Environment Specifications

 - Recommended Specification: 128C/1024G/4TB (Two 2TB disks) 
 - Recommended Model: AWS r6i.metal
 
  The first 2TB disk is used for the root directory and the second 2TB disk for swap space - setting aside 1.8TB for the swap will be sufficient.
  Please refer to [here](https://linuxize.com/post/create-a-linux-swap-file/).


#### 2）Operating System

Recommended to use Ubuntu 20.04

#### 3）Necessary Software Installation
```
Python3 #Default installation by operating system
Git #Default installation by operating system
gcc #Install Script: apt update -y && apt-get install -y gcc
Rust and Cargo, please refer to https://www.rust-lang.org/learn/get-started
```

#### 4）Download Phase 1's latest response file

Download the response of the latest participant from [phase 1](https://github.com/weijiekoh/perpetualpowersoftau/blob/master/0071_edward_response/README.md) into `phase2-bn254/loopring`. Rename the file to `response`.

#### 5）Deploy SFTP Server
SFTP is used for the automatic transfer and backup files from the participants executed scripts. Use [this script](https://github.com/degatedev/trusted_setup/blob/master/sftp.sh).


### General Preparation

#### 1）Create a Keybase Team Group
The group will be the official channel for the transmission of parameters transmission throughout the entire trusted setup process and also for the coordinator to provide assistance to the issues encountered by the participants.


#### 2）Announce & Retrieve Future Bitcoin Hash for the Execution of Beacon Contribution

The coordinator needs to make a public announcement of the furture selected bitcoin hash that will be the parameter for the random beacon used by `phase2-bn254` on DeGate's Twitter account before the trusted setup process begins.


### Steps for Coordinator

#### Initialization Part


#### Step 1: Download & Compile Source Code

##### 1）Download the 2 projects in the same folder

```
git clone https://github.com/degatedev/protocols --branch degate1.0.0
git clone https://github.com/degatedev/phase2-bn254
```


##### 2）Compile phase2-bn254

In phase2-bn254 directory，execute the following commands:

```
cd powersoftau && cargo build --release && \ 

cd ../phase2 && cargo build --release && \

cd ../loopring
````

##### 3）Make a copy of the latest response file
Copy the latest response file of phase one to the `phase2-bn254/loopring` directory.

##### 4）Beacon contribution
Update parameter with the Bitcoin Block Hash announced during the preparation stage to `phase2-bn254/powersoftau/src/bin/beacon_constrained.rs` file and execute the compilation at `phase2-bn254/powersoftau`

`  cargo build --release`


#### Step 2: prepare_phase2

Execute the following commands in `phase2-bn254/loopring` directory.

```console
../powersoftau/target/release/verify_transform_constrained -skipverification   #Generate the new_challenge file 

mv new_challenge challenge && mv response old_response #Rename file for subsequence procedure

../powersoftau/target/release/beacon_constrained  # Generate a new response file 

../powersoftau/target/release/prepare_phase2 #This step involves generating some phase1radix2m[serial number] files. 29 files in total.
```


#### Step 3: Circuit compilation

Execute in `protocols/packages/loopring_v3` directory.

```
./install

LIBRARY_PATH=$LIBRARY_PATH:/usr/local/lib/ make
```



#### Step 4: Generate contribution files for Phase 2

Execute in`phase2-bn254/loopring` directory.

`nohup python3 setup.py &`

This step will generate `loopring_mpc_0000.zip` and the file size is approximiately 160GB. The execution duration is estimated to be 70.5 hours and it will be uploaded to the `sftpuser0` directory of the SFTP server where the first participant will be able to download the file.



## Instructions to Guide Participants for Phase 2

### Communication Prior to Commencement of Participate Operations

1）Send the link that contains the participant documents to all participants in advance so that they will be able to familiarize with the related operational processes ahead of time

2）Notify the participant sequence number to each participant via Keybase and ensure that every participant is aware of their sequence

3）Send the SFTP private key for each participant over Keybase's private chat

4）Once the initial `loopring_mpc_0000.zip` file is generated, inform the `SHA256 hash` parameter in the `attestation.txt` file to all participant in the Keybase group channel where the first participant can utilise the information


### Coordinator's Verification Operation

When the participants completed their steps and sends the copied content of `signed_attestation.txt` to the Keybase group, the coordinator will be required to verify the output results and inform the hash value for the next participant.

#### 1）Verify participant's signed_attestation.txt using keybase website
Open [https://keybase.io/verify](https://keybase.io/verify) in the browser and make a copy of the participant's `signed_attestation.txt` content to `Message to verify` text box. Click on the Verify button where the message `Signed by UserName` will be returned.


#### 2）Uploading of participant's signed_attestation files
Upload every participant's `signed_attestation_000[x].txt` to [github](https://github.com/degatedev/trusted_setup/signed_attestation/)

Repeat the process of communication and verification until the last participant's computation has been completed.

*Note: The contribution verication will take 70 hours - once the last participant has completed the signing, multiple machines will be used for parallel execution of the contribution verification


### Verify the Contribution File of Every Participant


#### Preparing the verification machine
Once the last participant has completed the computation, prepare the same number of machines as the number of participants to verify all participant's output files in parallel.

##### 1）Operating System Specifications

  Recommended Specifications: 128C/1024G/4TB (Two 2TB Disks)
  Recommended Models: AWS r6i.metal
  
  The first 2TB disk is used for the root directory and the second 2TB disk for swap space - setting aside 1.8TB for the swap will be sufficient. Please refer to [here](https://linuxize.com/post/create-a-linux-swap-file/).


##### 2）Operating System

Recommended to use Ubuntu20.04

##### 3）Necessary Software Installation
```
Python3 #Default installation by system
Git #Default installation by system
gcc #Install Script: apt update -y && apt-get install -y gcc
Rust and Cargo, please refer to https://www.rust-lang.org/learn/get-started
```

#### Prepare verification environment


##### 1）Download the 2 projects in the same folder

```
git clone https://github.com/degatedev/protocols --branch degate1.0.0
git clone https://github.com/degatedev/phase2-bn254
```


##### 2）Compile phase2-bn254
In `phase2-bn254` execute the following commands:

```
cd powersoftau && cargo build --release && \ 

cd ../phase2 && cargo build --release && \

cd ../loopring
```


##### 3）Circuit Compilation

Execute in `protocols/packages/loopring_v3` directory.

```
./install

LIBRARY_PATH=$LIBRARY_PATH:/usr/local/lib/ make
```


#### Files transfer on verification environment

##### 1）Transfer the 29 files generated during the initialization (phase1radix2m0 ~ phase1radix2m28) to every verification machine in the phase2-bn254/loopring project directory


##### 2）Transfer the pending verifications and previous participation's contribution files to every machines in phase2-bn254/loopring directory.

  Every machine is only required to transfer files from the current and previous participants
  
>   Example：
> 
>   The machine that verifies the first participant's file is required to transfer loopring_mpc_0001.zip and loopring_mpc_0000.zip
> 
>   The machine that verifies the second participant's file is required to transfer loopring_mpc_0002.zip and loopring_mpc_0001.zip
> 
>   and etc...
> 
>   The machine that verifies the sixth (last) participant's file is required to transfer loopring_mpc_0005.zip and loopring_mpc_0006.zip


##### 3）Ensure that the current impending and previous verification participants share the same circuit code version (throughout the entire trusted set up process, do not update the branch code of the circuit)


#### Perform verification

Enter into `phase2-bn254/loopring/` directory and execute the command:

`nohup python3 verify_contribution.py participant sequence number & `

> Example：
> 
> To verify the first participant, the command is `nohup python3 verify_contribution.py 1` &
> 
> To verify the first participant, the command is `nohup python3 verify_contribution.py 2` &
> 
> etc...
> 
> To verify the first participant, the command is `nohup python3 verify_contribution.py 6` &
> 
> Once the verification is completed, the following log information will be outputted:
> 
> SHA256 hash of contribution:     <current hash>
> 
> SHA256 hash of previous contribution: <previous hash>
> 
> Circuit 1/6:
> Circuit 2/6:
> Circuit 3/6:
> Circuit 4/6:
> Circuit 5/6:
> Circuit 6/6:
> Circuit 7/7:
> Done! Contribution x is valid! #x is the verified participant serial number
> 
> 


### Execute Final Beacon Contribution
A beacon contribution is needed to be executed once the last participant file is completed (similar to the initialization beacon contribution).
    
The coordinator needs to make a public announcement of the furture selected bitcoin hash that will be the parameter for the random beacon used by `phase2-bn254` on DeGate's Twitter account a few hours before final beacon contribution.

    
Once the block is mined, place the block hash to the `cur_hash` parameter of `phase2-bn254/phase2/src/bin/beacon.rs`

Compile `phase2-bn254/phase2` directory.

`cargo build --release`

Execute the following command in the `phase2-bn254/loopring` directory.

`python3 contribute.py beacon`

This step generates the final `loopring_mpc_000x.zip` file where x= the sequence number of the last participant + 1. This execution process will take approximately 3 hours.

### Export pk and vk
Execute the export function that will take approximately 12 hours

Execute the following command in `phase2-bn254/loopring` directory:

```
nohup python3 export_keys.py &
This step generates a list of files under the protocols/packages/loopring_v3/keys directory and is named as all_[circuitsize]_vk.json ，all_[circuitsize]_pk.raw)
```
