#!bin/bash
#vina batch docking script
#author: scu-ljy

# 为了确保可以正常切换conda环境
source ~/miniconda3/etc/profile.d/conda.sh

echo "开始批处理docking:"


echo "请输入本次docking的根目录, 以绝对路径给出 (例: /home/chaoyideng/Dy/ADT/m55/"
read DIR
echo "请输入包含多个分子的文件名(不包含.mol2, 例: 20210521_Mol55):"
read INPF
echo "请输入保存每个分子的文件名前缀(不包含.mol2, 例: m55):"
read OUTF
echo "请输入文件中含有的分子个数:"
read N
echo "请输入配置文件的绝对路径（例：/home/chaoyideng/Dy/ADT/config_file.arg):"
read CONFIG_FILE
echo "请输入输出日志文件的名字（不包含.log, 例: docking_log):"
read LOG_FILE
echo "请输入转存日志文件的文件夹(例: logs):"
read LOG_FOLDER
echo "请输入亲和度数据文件名(例: affinity.out)"
read AFFINITY_FILE
echo "请输入分子compound前缀名(例: AL, m3000, m2000等)"
read PREFIX

num=$(expr $N + 0)

CURRENT_DIR=$(pwd)
echo "当前目录为：$CURRENT_DIR"

echo "切换至:${DIR}目录"
cd $DIR

echo "1. 用obabel将含有多个分子的mol2文件拆分成多个mol2文件:"
# 用obabel将含有多个分子的mol2文件拆分成多个mol2文件
conda activate vina
# /home/chaoyideng/miniconda3/envs/vina/bin/obabel -i mol2 ${INPF}.mol2 -o mol2 -O ${OUTF}_.mol2 -m
obabel -i mol2 ${INPF}.mol2 -o mol2 -O ${OUTF}_.mol2 -m
conda deactivate


echo "2. 批量创建文件夹，并将配体放入个字文件夹内，统一命名配体名称"

# 批量创建文件夹
mkdir $(eval echo {1..${num}})

# 将配体放入个字文件夹内，并重命名
for i in $(eval echo {1..${num}});do
  mv ./${OUTF}_${i}.mol2 ./$i/${OUTF}.mol2;
done

echo "3. 批量将mol2文件转换为pdbqt"
# 激活mgltools环境，因为基于python2
conda activate mgltools
for i in $(eval echo {1..${num}});do
  cd ./$i;
  prepare_ligand4.py -l ${OUTF}.mol2 -o ${OUTF}.pdbqt;
  echo "转换文件${i}完成!";
  cd ../;
done
conda deactivate

echo "4. 使用vina批量对接, 并将结果输出到每个文件夹中的log文件"
conda activate vina
for i in $(eval echo {1..${num}});do
  cd ./$i;
  vina --config $CONFIG_FILE > ./$LOG_FILE.log;
  echo "对接完第${i}个分子!";
  cd ../;
done
conda deactivate

echo "5. 对接完成, 提取log日志文件"
mkdir $LOG_FOLDER
for i in $(eval echo {1..${num}});do
  cd ./$i;
  mv $LOG_FILE.log ../$LOG_FOLDER/${LOG_FILE}_${i}.log
  cd ../;
done

echo "6. 提取亲和度数据至输出文件$AFFINITY_FILE"
python $CURRENT_DIR/affinity_extract.py "$LOG_FOLDER" "$PREFIX"

#切换回之前的目录
cd $CURRENT_DIR
