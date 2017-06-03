# stratis-dockerfile
Dockerfile for StratisX Daemon + Staking

### Build Docker Image
    docker build -t stratis .
    
### Create Data Directory
    mkdir -p /var/run/stratis

### Create `stratis.conf` Configuration File
    cd /var/run/stratis
    touch ./stratis.conf
    nano ./stratis.conf
    
*Example:*
```
rpcuser=stratisrpc
rpcpassword=Super$ecretPassw0rd!
rpcallowip=172.17.*.*
rpcport=16174
port=
gen=0
server=1
staking=1

addnode=104.129.29.82
addnode=104.136.222.147
```

**NOTE:** `stratisd` also can use this file for connecting to a remote RPC server.

### Optional: Copy Wallet
    cp ~/.stratis/wallet.dat /var/run/stratis

**WARNING:** Always backup your wallet, as sudden termination of the container can cause corruption.

### Optional: Copy Existing Chain Data to Sync Even Faster
    cp ~/.stratis/blk*.dat /var/run/stratis
    
### Run Docker Container
    docker run \
      --detach \
      --publish 16174:16174 \
      --volume /var/run/stratis:/mnt/stratis \
      --env WALLET_PASSPHRASE=your_wallet_passphrase \
      --name stratis-container \
      stratis
      
**NOTE:** Your wallet will automatically be unlocked and start staking when the container is run. It is important that your wallet passphrase is set correctly (above) in order for this to work properly.

### Tail Container Logs
    docker logs -f stratis-container
