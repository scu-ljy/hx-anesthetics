import glob
import sys
import os

path = sys.argv[1]
prefix = sys.argv[2]

log_file = glob.glob(os.path.join(path, '*.log'))

print(log_file)

with open("affinity.out", "w", encoding='utf-8') as outf:
    for file in log_file:
        with open(file, "r", encoding='utf-8') as inpf:
            data = inpf.readlines()
            for line in data:
                if len(line.split()) >= 2 and line.split()[0] == "1":
                    # TODO: 这里需要改进一下名字
                    affinity = prefix + '_' + file.split('_')[-1].split('.')[0] + "\t" + line.split()[1]
                    print(affinity)
                    outf.writelines(affinity+'\n')

