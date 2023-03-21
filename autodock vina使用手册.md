# 准备批量的小分子：

### 准备好需要docking的小分子数据（mol2格式）
### 小分子mol2文件拆分，以及转换为pdbqt

先进入到你的目录文件 `cd ~/Dy/ADT`，如果你的目录文件变了，则可以根据需要修改`Dy/ADT`

1. 使用babel 
   
  - 激活babel环境 `conda activate vina`
  - 执行obabel命令 `obabel -i mol2 input.mol2 -o mol2 -O output_.mol2 -m`（可用`obabel -H`查看各选项的说明，input, output可替换成自己想要的文件名，建议在output之后加一个下划线_）
  
2. 批量创建文件夹 
   
   `mkdir {1..N}`（N为需要被docking的分子数量）

3. 批量将配体放入文件夹下 
   
   `for i in {1..N};do mv ./output_${i}.mol2 ./$i;done`（N为需要被docking的分子数量，filename可替换成自己想要的文件名）

4. 将每个文件夹内的配体统一命名为：output.mol2

   `for i in {1..N};do cd ./$i;mv output_*.mol2 ./output.mol2;cd ../;done`（N为需要被docking的分子数量，output可替换成自己想要的文件名，这里output后面因为没有跟数字，可以去掉下划线_）

5. 批量将mol2文件转换为pdbqt
  - 激活mgltools环境  `conda deactivate; conda activate mgltools`
  - 执行: `for i in {1..N};do cd ./$i;prepare_ligand4.py -l output.mol2 -o output.pdbqt;echo $i;cd ../;done`（N为需要被docking的分子数量，output可替换成自己想要的文件名）

6. 批量对接
  - 新打开一个终端（教程上为：建立后台终端 `screen -R test2` ）
  - 激活vina环境  `conda activate vina`
  执行: `for i in {1..N};do cd ./$i;vina --config config_file.arg;echo $i;cd ../;done > ./$i/docking_log.log` （N为需要被docking的分子数量，config_file和log_file分别为你的配置文件和日志文件，两者可以替换为自己设定的路径+文件名，.arg和.log不用替换，配置文件需要用绝对路径来标出受体文件的位置）
   

  
  
