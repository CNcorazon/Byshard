package main

import (
	"fmt"
	"io/ioutil"
	"regexp"
	"strconv"
	"strings"
)

type NodeKey struct {
	ID      string `json:"id,omitempty"`
	PrivKey struct {
		Type  string `json:"type"`
		Value string `json:"value"`
	} `json:"priv_key"`
}

func main() {
	maxCount := 100 // 替换为实际的shard数量
	nodeCount := 1  // 每个shard中的node数量固定为10
	for shardCount := 100; shardCount <= maxCount; shardCount += 5 {
		findAndUpdateNodeKey(shardCount, nodeCount)
	}
}

func findAndUpdateNodeKey(shardCount, nodeCount int) {
	for shardNum := 0; shardNum < shardCount; shardNum++ {
		for nodeNum := 0; nodeNum < nodeCount; nodeNum++ {
			configPath := fmt.Sprintf("test/tps_shard_num/elrond_%dshard_%dnode/shard%d/node%d/config/config.toml", shardCount, nodeCount, shardNum, nodeNum)
			// nodeKeyPath := fmt.Sprintf("test/tps_shard_num/elrond_%dshard_%dnode/shard%d/node%d/config/node_key.json", shardCount, nodeCount, shardNum, nodeNum)

			// 读取config.toml文件内容
			configData, err := ioutil.ReadFile(configPath)
			if err != nil {
				fmt.Printf("Error reading config.toml: %v\n", err)
				continue
			}

			// nodeID := findNodeID(string(configData), nodeNum)
			// if nodeID == "" {
			// 	fmt.Printf("NodeID not found for node%d\n", nodeNum)
			// 	continue
			// }

			// // 读取node_key.json文件内容
			// nodeKeyData, err := ioutil.ReadFile(nodeKeyPath)
			// if err != nil {
			// 	fmt.Printf("Error reading node_key.json: %v\n", err)
			// 	continue
			// }

			// // 更新node_key.json文件内容
			// var nodeKey NodeKey
			// err = json.Unmarshal(nodeKeyData, &nodeKey)
			// if err != nil {
			// 	fmt.Printf("Error unmarshalling node_key.json: %v\n", err)
			// 	continue
			// }
			// nodeKey.ID = nodeID
			// newNodeKeyData, err := json.MarshalIndent(nodeKey, "", "  ")
			// if err != nil {
			// 	fmt.Printf("Error marshalling updated node_key.json: %v\n", err)
			// 	continue
			// }

			// // 将更新后的node_key.json文件内容写回文件
			// err = ioutil.WriteFile(nodeKeyPath, newNodeKeyData, 0644)
			// if err != nil {
			// 	fmt.Printf("Error writing updated node_key.json: %v\n", err)
			// 	continue
			// }

			// 更新config.toml文件内容
			updatedConfigData := updateConfigToml(string(configData), shardNum, nodeNum)

			// 将更新后的config.toml文件内容写回文件
			err = ioutil.WriteFile(configPath, []byte(updatedConfigData), 0644)
			if err != nil {
				fmt.Printf("Error writing updated config.toml: %v\n", err)
				continue
			}
		}
	}
}

// func findNodeID(configData string, nodeNum int) string {
// 	re := regexp.MustCompile(`persistent_peers\s*=\s*"([^"]*)"`)
// 	matches := re.FindStringSubmatch(configData)
// 	if len(matches) < 2 {
// 		return ""
// 	}
// 	peers := strings.Split(matches[1], ",")
// 	for _, peer := range peers {
// 		peerParts := strings.Split(peer, "@")
// 		if len(peerParts) < 2 {
// 			continue
// 		}
// 		nodeID := strings.TrimSpace(peerParts[0])
// 		ipAddr := strings.TrimSpace(peerParts[1])
// 		ipAndPort := strings.Split(ipAddr, ":")
// 		if len(ipAndPort) < 2 {
// 			continue
// 		}
// 		ipParts := strings.Split(ipAndPort[0], ".")
// 		if len(ipParts) < 4 {
// 			continue
// 		}
// 		ipNum, err := strconv.Atoi(ipParts[3])
// 		if err == nil && ipNum == nodeNum+1 {
// 			return nodeID
// 		}
// 	}
// 	return ""
// }

func updateConfigToml(configData string, shardNum, nodeNum int) string {
	// Update proxy_app field
	proxyAppRe := regexp.MustCompile(`(proxy-app\s*=\s*)"tcp://\d+.\d+.\d+.\d+:(\d+)"`)
	if shardNum > 29 && shardNum <= 59 {
		shardNum -= 30
		nodeNum += 1
	}
	if shardNum > 59 && shardNum <= 89 {
		shardNum -= 60
		nodeNum += 2
	}
	if shardNum > 89 {
		shardNum -= 90
		nodeNum += 3
	}
	proxyAppReplacement := fmt.Sprintf("$1\"tcp://192.168.0.166:%d%d58\"", shardNum+20, nodeNum)
	updatedConfigData := proxyAppRe.ReplaceAllString(configData, proxyAppReplacement)

	// Update laddr field
	laddr1 := regexp.MustCompile(`(laddr\s*=\s*)"tcp://0.0.0.0:\d+"`)
	laddrReplacement1 := fmt.Sprintf("$1\"tcp://0.0.0.0:%d%d56\"", shardNum+20, nodeNum)
	updatedConfigData = laddr1.ReplaceAllString(updatedConfigData, laddrReplacement1)

	laddr2 := regexp.MustCompile(`(laddr\s*=\s*)"tcp://127.0.0.1:\d+"`)
	laddrReplacement2 := fmt.Sprintf("$1\"tcp://192.168.0.166:%d%d57\"", shardNum+20, nodeNum)
	updatedConfigData1 := laddr2.ReplaceAllString(updatedConfigData, laddrReplacement2)

	// Update persistent_peers field
	persistentPeersRe := regexp.MustCompile(`(persistent-peers\s*=\s*")([^"]*)`)
	matches := persistentPeersRe.FindStringSubmatch(updatedConfigData1)
	if len(matches) > 2 {
		newPeers := []string{}
		peers := strings.Split(matches[2], ",")
		for _, peer := range peers {
			peerParts := strings.Split(peer, "@")
			if len(peerParts) < 2 {
				continue
			}

			nodeID := strings.TrimSpace(peerParts[0])
			ipAddr := strings.TrimSpace(peerParts[1])

			ipAndPort := strings.Split(ipAddr, ":")
			if len(ipAndPort) < 2 {
				continue
			}

			ipParts := strings.Split(ipAndPort[0], ".")
			if len(ipParts) < 4 {
				continue
			}

			ipNum, err := strconv.Atoi(ipParts[3])
			if err == nil && ipNum != nodeNum+1 {
				newPeers = append(newPeers, fmt.Sprintf("%s@192.168.0.166:%d%d56", nodeID, shardNum+20, ipNum-1))
			}
		}
		updatedPeers := strings.Join(newPeers, ",")
		updatedConfigData1 = persistentPeersRe.ReplaceAllString(updatedConfigData1, fmt.Sprintf("%s%s", matches[1], updatedPeers))
	}

	// Update create_empty_blocks field
	createEmptyBlocksRe := regexp.MustCompile(`(create-empty-blocks\s*=\s*).*`)
	updatedConfigData1 = createEmptyBlocksRe.ReplaceAllString(updatedConfigData1, "${1}false")

	// Update grpc-max-open-connections and max-open-connections fields
	grpcMaxConn := regexp.MustCompile(`grpc-max-open-connections\s*=\s*\d+`)
	updatedConfigData1 = grpcMaxConn.ReplaceAllString(updatedConfigData1, "grpc-max-open-connections = 0")

	maxConn := regexp.MustCompile(`max-open-connections\s*=\s*\d+`)
	updatedConfigData1 = maxConn.ReplaceAllString(updatedConfigData1, "max-open-connections = 0")

	// Update send-rate and recv-rate fields
	sendRate := regexp.MustCompile(`send-rate\s*=\s*\d+`)
	updatedConfigData1 = sendRate.ReplaceAllString(updatedConfigData1, "send-rate = 1048576")

	recvRate := regexp.MustCompile(`recv-rate\s*=\s*\d+`)
	updatedConfigData1 = recvRate.ReplaceAllString(updatedConfigData1, "recv-rate = 1048576")

	// Update prometheus-listen-addr field
	prometheusListenAddrRe := regexp.MustCompile(`(prometheus-listen-addr\s*=\s*").+`)
	prometheusListenAddrReplacement := fmt.Sprintf("$1:%d%d60\"", shardNum+20, nodeNum)
	updatedConfigData1 = prometheusListenAddrRe.ReplaceAllString(updatedConfigData1, prometheusListenAddrReplacement)

	// // Update max-subscription-clients field
	// maxSubscriptionClientsRe := regexp.MustCompile(`(max-subscription-clients\s*=\s*).*`)
	// updatedConfigData1 = maxSubscriptionClientsRe.ReplaceAllString(updatedConfigData1, "${1}1000000")

	// // Update max-subscriptions-per-client field
	// maxSubscriptionsPerClientRe := regexp.MustCompile(`(max-subscriptions-per-client\s*=\s*).*`)
	// updatedConfigData1 = maxSubscriptionsPerClientRe.ReplaceAllString(updatedConfigData1, "${1}1000000")

	return updatedConfigData1
}
