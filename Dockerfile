# docker build -t truebit-eth-server .
#
# YYY=$HOME'/truebit-docker'
# docker run --network host -v $YYY/docker-clef:/root/.clef \
#	-v $YYY/docker-geth:/root/.ethereum \
#	-v $YYY/docker-ipfs:/root/.ipfs \
#	-v $YYY/wasm-bin:/root/wasm-bin \
#   -e TBMODE=solver \
#   -e TBNETWORK=goerli \
#   -e TBPASS=clefpasswd \
#.  -e TBWALLET=wallet_id \
#	--name truebit --rm -d -it truebit-eth-server:latest
#
# valid values for TBMODE are init, solver, or verifier. Bad or missing arg defaults to init.
# valid values for TBNETWORK are mainnet or goerli. Default is goerli.
# valid values for TBWALLET are 0-n, corresponding to the account ID in clef and truebit-os. Defaults to 0
# TBPASS should be defined using methods that do not disclose the actual password on the Docker command line 
#  (e.g. stty -echo, mypass="xxxx", stty echo   and then use -e TBPASS=$mypass )

FROM truebitprotocol/truebit-eth:latest
MAINTAINER truebit

# Get missing parts in 1 layer
RUN apt-get update && apt-get install -y dialog screen ; mkdir /root/logs ; echo "PS1='${debian_chroot:+($debian_chroot)}\u@\h(truebit-eth-server):\w\$ '" >> /root/.bashrc

# Copy our scripts to a good spot
ADD ./scripts /tbscripts

# Open IPFS and blockchain ports
EXPOSE 4001 8080 8545 8546 30303

CMD bash /tbscripts/start.sh
