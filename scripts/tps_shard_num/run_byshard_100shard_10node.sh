source ~/.bashrc
GOSRC=$GOPATH/src
TEST_SCENE="byshard"
TM_HOME="$HOME/.haechibyshard"
WORKSPACE="$GOSRC/github.com/AFukun/haechi"
CURRENT_DATE=`date +"%Y-%m-%d-%H-%M"`
LOG_DIR="$WORKSPACE/tmplog/$TEST_SCENE-$CURRENT_DATE"
DURATION=60

SHARD_NUM=100
SHARD_SIZE=1
BEACON_PORT=10057
BEACON_IP="127.0.0.1"
SHARD_PORTS="20057,21057,22057,23057,24057,25057,26057,27057,28057,29057,30057,31057,32057,33057,34057,35057,36057,37057,38057,39057,40057,41057,42057,43057,44057,45057,46057,47057,48057,49057,20157,21157,22157,23157,24157,25157,26157,27157,28157,29157,30157,31157,32157,33157,34157,35157,36157,37157,38157,39157,40157,41157,42157,43157,44157,45157,46157,47157,48157,49157,20257,21257,22257,23257,24257,25257,26257,27257,28257,29257,30257,31257,32257,33257,34257,35257,36257,37257,38257,39257,40257,41257,42257,43257,44257,45257,46257,47257,48257,49257,20357,21357,22357,23357,24357,25357,26357,27357,28357,29357"
SHARD_IPS="192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166,192.168.0.166"

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

cp -r test/tps_shard_num/elrond_100shard_1node/* $TM_HOME
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
