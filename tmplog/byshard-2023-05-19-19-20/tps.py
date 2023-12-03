import re
import glob
from datetime import datetime


def calculate_time_difference(log_file):
    with open(log_file, 'r') as file:
        lines = file.readlines()
        first_line = lines[0].strip().split(' ')[0].replace(':', '')
        last_line = lines[-1].strip().split(' ')[0].replace(':', '')

    # 定义时间格式
    time_format = "%Y-%m-%dT%H%M%S%z"

    # 将字符串转换为 datetime 对象
    start_time = datetime.strptime(first_line, time_format)
    end_time = datetime.strptime(last_line, time_format)

    # 计算时间差并转换为秒
    time_difference = (end_time - start_time).total_seconds()

    return time_difference


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

    # 使用你的日志文件名替换 'your_log_file.log'
    # 找到所有匹配模式 'shard*-node0.log' 的文件
    log_files = glob.glob('shard*-node0.log')
    count = 0
    time = 0
    # 对每个文件进行处理
    for log_file in log_files:
        print(log_file)
        if calculate_time_difference(log_file) >=8 :
            time += calculate_time_difference(log_file)
            count += 1
        
        # print(log_file)
        print(
            f"File: {log_file}, Time Difference: {calculate_time_difference(log_file)} seconds")

    print(count,time/count)
    log_data = read_log_files(file_pattern)
    total_valid_txs, block_num = parse_and_sum_valid_txs(log_data)
    tps = total_valid_txs/(time/count)
    block_num = block_num/(count)
    print(f"Total valid transactions: {total_valid_txs}")
    print(f"Tps: {tps}")
    print(f"Blocks: {block_num}")


if __name__ == "__main__":
    main()
