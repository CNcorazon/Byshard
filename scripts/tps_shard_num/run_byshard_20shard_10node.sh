source ~/.bashrc
GOSRC=$GOPATH/src
TEST_SCENE="byshard"
TM_HOME="$HOME/.haechibyshard"
WORKSPACE="$GOSRC/github.com/AFukun/haechi"
CURRENT_DATE=`date +"%Y-%m-%d-%H-%M"`
LOG_DIR="$WORKSPACE/tmplog/$TEST_SCENE-$CURRENT_DATE"
DURATION=60

SHARD_NUM=20
SHARD_SIZE=10
BEACON_PORT=10057
BEACON_IP="127.0.0.1"
SHARD_PORTS="20057,21057,22057,23057,24057,25057,26057,27057,28057,29057,30057,31057,32057,33057,34057,35057,36057,37057,38057,39057"
SHARD_IPS="192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166"

while getopts ":n:m:p:i:s:x:d:" opt
do 
    case $opt in
    n) # shard number
        echo "shard number is $OPTARG"
        SHARD_NUM=$OPTARG
        ;;
    m) # shard size
        echo "shard size is $OPTARG"
        SHARD_SIZE=$OPTARG
        ;;  
    p) # beacon port
        echo "beaconport is $OPTARG"
        BEACON_PORT=$OPTARG
        ;;  
    i) # beacon ip
        echo "beaconip is $OPTARG"
        BEACON_IP=$OPTARG
        ;;  
    s) # shard ports
        echo "shardports is $OPTARG"
        SHARD_PORTS=$OPTARG
        ;;  
    x) # shard ips
        echo "shardips is $OPTARG"  
        SHARD_IPS=$OPTARG
        ;;
    d) # executing duration
        echo "duration is $OPTARG"  
        DURATION=$OPTARG
        ;;  
    ?)  
        echo "unknown: $OPTARG"
        ;;
    esac
done

rm -rf $TM_HOME/*
mkdir -p $TM_HOME
mkdir -p $LOG_DIR

cp -r test/tps_shard_num/elrond_20shard_10node/* $TM_HOME
echo "configs generated"

pkill -9 byshard

# run shard node
for ((j=0;j<$SHARD_NUM;j++))
do
    for ((k=0;k<$SHARD_SIZE;k++))
    do
        if [ $k -eq 0 ]; then
            echo "running shard$j leader"
            ./build/byshard -home $TM_HOME/shard$j/node$k -leader "true" -shards $SHARD_NUM -shardid $j -beaconport $BEACON_PORT -shardports $SHARD_PORTS -beaconip $BEACON_IP -shardips $SHARD_IPS &> $LOG_DIR/shard$j-node$k.log &
        else
            echo "running shard$j validator$k"
            ./build/byshard -home $TM_HOME/shard$j/node$k -leader "false" -shards $SHARD_NUM -shardid $j -beaconport $BEACON_PORT -shardports $SHARD_PORTS -beaconip $BEACON_IP -shardips $SHARD_IPS &> $LOG_DIR/shard$j-node$k.log &
        fi
    sleep 0.1
    done
done

echo "testnet launched"
echo "running for ${DURATION}s..."
sleep $DURATION
pkill -9 byshard
echo "all done"
