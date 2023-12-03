import re
import glob


def read_log_files(file_pattern):
    file_paths = glob.glob(file_pattern)
    content = []

    for file_path in file_paths:
        with open(file_path, 'r') as file:
            content.extend(file.readlines())

    return content


def parse_and_sum_valid_txs(log_data):
    valid_txs_pattern = r"num_valid_txs=(\d+)"
    total_valid_txs = 0
    blockcount = 0

    for line in log_data:
        match = re.search(valid_txs_pattern, line)
        if match:
            num_valid_txs = int(match.group(1))
            blockcount += 1
            total_valid_txs += num_valid_txs

    return total_valid_txs, blockcount


def main():
    # Replace with the appropriate file pattern if necessary
    file_pattern = 'shard*-node0.log'
    log_data = read_log_files(file_pattern)
    total_valid_txs, block_num = parse_and_sum_valid_txs(log_data)
    tps = total_valid_txs/60
    block_num = block_num/10
    print(f"Total valid transactions: {total_valid_txs}")
    print(f"Tps: {tps}")
    print(f"Blocks: {block_num}")


if __name__ == "__main__":
    main()
