#!/bin/bash
GOSRC=$GOPATH/src
ROOT=$GOSRC/github.com/AFukun/haechi


num_nodes=1
max_shards=100

for ((num_shards=100; num_shards<=$max_shards; num_shards+=5)); do 
  for ((i=0; i<$num_shards; i++)); do
    tendermint testnet --v $num_nodes --o $ROOT/test/tps_shard_num/elrond_${num_shards}shard_${num_nodes}node/shard$i --populate-persistent-peers --starting-ip-address 127.0.0.1
  done
done
