#!/bin/bash

#define parameter
contribution_number=$1
previous_contribution_hash=$2
random_text=$3
download_number=`expr ${contribution_number} - 1`
file_path="/opt/phase2-bn254/loopring"
mount_path="/opt/trustmount"

#Download and Compile source code
echo "Step 1 : Download and Compile source code" 2>&1 | tee >> /opt/trustmount/trusted-setup.log
cd /opt/ && /usr/bin/git clone https://github.com/degatedev/phase2-bn254.git && cd /opt/phase2-bn254/phase2 && /root/.cargo/bin/cargo build --release 2>&1 | tee >> /opt/trustmount/trusted-setup.log

sleep 30
ls /opt/phase2-bn254/phase2/target
if [ $? != 0 ]
then
    echo "Step 1 : Download and Compile source code error,please contact coordinator" 2>&1 | tee >> /opt/trustmount/trusted-setup.log
    exit 1
fi

#Download the previous contribution zip file from sftp server
echo "Step 2 : Download the previous contribution zip file from sftp server" 2>&1 | tee >> /opt/trustmount/trusted-setup.log
chmod 600 ${mount_path}/sftpuser${contribution_number}.key
cd ${file_path} && /usr/bin/sftp -o StrictHostKeyChecking=no  -i ${mount_path}/sftpuser${contribution_number}.key  sftpuser${contribution_number}@trust-setup-ftp.degate.com <<EOF
cd sftpuser${download_number}
lcd ${file_path}
get loopring_mpc_000${download_number}.zip
bye
EOF

sleep 30
ls ${file_path}/loopring_mpc_000${download_number}.zip
if [ $? != 0 ]
then
    echo "Step 2 : Download the previous contribution zip file error,please contact coordinator" 2>&1 | tee >> /opt/trustmount/trusted-setup.log
    exit 1
fi

#Start contribution
echo "Step 3 : Start contribution,this process takes a long time, more than 10 hours" 2>&1 | tee >> /opt/trustmount/trusted-setup.log
cd ${file_path} && /usr/bin/python3 ${file_path}/contribute.py $previous_contribution_hash $random_text 2>&1 | tee >> /opt/trustmount/trusted-setup.log

sleep 30
ls ${file_path}/loopring_mpc_000${contribution_number}.zip
if [ $? != 0 ]
then
    grep "Starting from contribution" /opt/phase2-bn254/loopring/attestation.txt 2>&1 | tee >> /opt/trustmount/trusted-setup.log
    echo "Step 3 : contribution error,please contact coordinator" 2>&1 | tee >> /opt/trustmount/trusted-setup.log
    exit 1
fi

#Upload contribution file to sftp server
echo "Step 4 : Upload contribution file to sftp server" 2>&1 | tee >> /opt/trustmount/trusted-setup.log
cd ${file_path} && /usr/bin/sftp -o StrictHostKeyChecking=no  -i ${mount_path}/sftpuser${contribution_number}.key  sftpuser${contribution_number}@trust-setup-ftp.degate.com <<EOF
cd sftpuser${contribution_number}
lcd ${file_path}
put loopring_mpc_000${contribution_number}.zip
bye
EOF

cp ${file_path}/attestation.txt /opt/trustmount/attestation.txt
echo "Step 5 : Upload contribution file success,please fill in the information into your attestation.txt" 2>&1 | tee >> /opt/trustmount/trusted-setup.log
