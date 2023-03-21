# vina_docking.sh使用方法 
1. vina_docking.sh和affinity_extract.py脚本在`/home/chaoyideng/Dy/ADT/`目录，以后不需要复制这些脚本到docking环境，只需进入该目录`cd /home/chaoyideng/Dy/ADT/`执行即可
2. 通过`bash vina_docking.sh`运行脚本，也可以用`bash vina_docking.sh 2>&1 | tee results.log`命令来保存结果至results.log文件
3. 开始需要输入一些参数来确保脚本正确运行，首先需要指定docking所需要完成的根目录,例如`/home/chaoyideng/Dy/ADT/m55/`, 其他参数请参照提示输入，输入时不要有多余空格等符号；每输入一个参数，按回车输入下一个
4. 等参数输完以后，开始执行，静候佳音！
