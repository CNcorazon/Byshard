.PHONY: build create_testnet run_testnet

build:
	bash ./scripts/go_build_executables.sh

run_testnet:
	bash ./scripts/run_testnet.sh

run_ahltest:
	bash ./scripts/run_ahl.sh

run_byshardtest:
	bash ./scripts/run_byshard.sh

run_haechitest:
	bash ./scripts/run_haechi.sh

#haechi
run_haechi_2shard_4node_test:
	bash ./scripts/run_haechi_2shard_4node.sh

run_haechi_4shard_4node_test:
	bash ./scripts/run_haechi_4shard_4node.sh

run_haechi_6shard_4node_test:
	bash ./scripts/run_haechi_6shard_4node.sh

run_haechi_8shard_4node_test:
	bash ./scripts/run_haechi_8shard_4node.sh

run_haechi_10shard_4node_test:
	bash ./scripts/run_haechi_10shard_4node.sh

run_haechi_12shard_4node_test:
	bash ./scripts/run_haechi_12shard_4node.sh

run_haechi_14shard_4node_test:
	bash ./scripts/run_haechi_14shard_4node.sh

run_haechi_16shard_4node_test:
	bash ./scripts/run_haechi_16shard_4node.sh

run_haechi_16shard_4node_8beacon_test:
	bash ./scripts/run_haechi_16shard_4node_8beacon.sh

run_haechi_16shard_4node_12beacon_test:
	bash ./scripts/run_haechi_16shard_4node_12beacon.sh

run_haechi_16shard_4node_16beacon_test:
	bash ./scripts/run_haechi_16shard_4node_16beacon.sh

run_haechi_16shard_4node_20beacon_test:
	bash ./scripts/run_haechi_16shard_4node_20beacon.sh

run_haechi_16shard_8node_test:
	bash ./scripts/run_haechi_16shard_8node.sh

run_haechi_16shard_12node_test:
	bash ./scripts/run_haechi_16shard_12node.sh

run_haechi_16shard_16node_test:
	bash ./scripts/run_haechi_16shard_16node.sh

run_haechi_16shard_20node_test:
	bash ./scripts/run_haechi_16shard_20node.sh

# ahl
run_ahl_2shard_4node_test:
	bash ./scripts/run_ahl_2shard_4node.sh

run_ahl_4shard_4node_test:
	bash ./scripts/run_ahl_4shard_4node.sh

run_ahl_6shard_4node_test:
	bash ./scripts/run_ahl_6shard_4node.sh

run_ahl_8shard_4node_test:
	bash ./scripts/run_ahl_8shard_4node.sh

run_ahl_10shard_4node_test:
	bash ./scripts/run_ahl_10shard_4node.sh

run_ahl_12shard_4node_test:
	bash ./scripts/run_ahl_12shard_4node.sh

run_ahl_14shard_4node_test:
	bash ./scripts/run_ahl_14shard_4node.sh

run_ahl_16shard_4node_test:
	bash ./scripts/run_ahl_16shard_4node.sh

run_ahl_16shard_8node_test:
	bash ./scripts/run_ahl_16shard_8node.sh

run_ahl_16shard_12node_test:
	bash ./scripts/run_ahl_16shard_12node.sh

run_ahl_16shard_16node_test:
	bash ./scripts/run_ahl_16shard_16node.sh

run_ahl_16shard_20node_test:
	bash ./scripts/run_ahl_16shard_20node.sh

#byshard
run_byshard_2shard_4node_test:
	bash ./scripts/run_byshard_2shard_4node.sh

run_byshard_4shard_4node_test:
	bash ./scripts/run_byshard_4shard_4node.sh

run_byshard_6shard_4node_test:
	bash ./scripts/run_byshard_6shard_4node.sh

run_byshard_8shard_4node_test:
	bash ./scripts/run_byshard_8shard_4node.sh

run_byshard_10shard_4node_test:
	bash ./scripts/run_byshard_10shard_4node.sh

run_byshard_12shard_4node_test:
	bash ./scripts/run_byshard_12shard_4node.sh

run_byshard_14shard_4node_test:
	bash ./scripts/run_byshard_14shard_4node.sh

run_byshard_16shard_4node_test:
	bash ./scripts/run_byshard_16shard_4node.sh

run_byshard_16shard_8node_test:
	bash ./scripts/run_byshard_16shard_8node.sh

run_byshard_16shard_12node_test:
	bash ./scripts/run_byshard_16shard_12node.sh

run_byshard_16shard_16node_test:
	bash ./scripts/run_byshard_16shard_16node.sh

run_byshard_16shard_20node_test:
	bash ./scripts/run_byshard_16shard_20node.sh


run_byshard_5shard_10node_test:
	bash ./scripts/tps_shard_num/run_byshard_5shard_10node.sh

run_byshard_10shard_10node_test:
	bash ./scripts/tps_shard_num/run_byshard_10shard_10node.sh

run_byshard_15shard_10node_test:
	bash ./scripts/tps_shard_num/run_byshard_15shard_10node.sh

run_byshard_20shard_10node_test:
	bash ./scripts/tps_shard_num/run_byshard_20shard_10node.sh

run_byshard_25shard_10node_test:
	bash ./scripts/tps_shard_num/run_byshard_25shard_10node.sh

run_byshard_30shard_10node_test:
	bash ./scripts/tps_shard_num/run_byshard_30shard_10node.sh

run_byshard_100shard_10node_test:
	bash ./scripts/tps_shard_num/run_byshard_100shard_10node_test
