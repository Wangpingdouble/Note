[TOC]

### 1、shell 使用指定的分割符来分割字符串

- 方法一：

~~~powershell
#!/bin/bash
string="hello,shell,haha"  
array=(${string//,/ })  
for var in ${array[@]}
do
   echo $var
done 
~~~

- 方法二：

~~~shell
#!/bin/bash
string="hello,shell,haha"
OLD_IFS="$IFS"
IFS=","
array=($string)
IFS="$OLD_IFS"
for var in ${array[@]}
do
   echo $var
done
~~~

### 2、shell if判空

~~~shell
if test -z "$dmin"
  then
  	 echo "dmin is not set!"
  else  
     echo "dmin is set !"
fi
~~~

### 3、shell 获取时间

获取当日时间

```shell
v_date=date +%Y-%m-%d
echo $v_date
2018-03-06
```

获取明天的日期

```shell
date -d next-day +%Y%m%d
```

获取昨天的日期

```shell
date -d last-day +%Y%m%d 或 date -d yesterday +%Y%m%d
```

获取上个月的年和月

```shell
date -d last-month +%Y%m
```

获取下个月的年和月

```shell
date -d next-month +%Y%m
```

获取明年的年份

```shell
date -d next-year +%Y
```

### 4、shell脚本调用方法

```shell
function reload(){
	...
	...
return 0
}
reload 参数1 参数2;

```

### 5、连接lftp或sftp获取文件

```Shell
lftp sftp://username:pwd@url<<EOF
	mget 文件所在地址
	exit;
EOF
如：
	lftp sftp://zgs:'#EEDC4rfv'@10.186.123.135:22<<EOF
		mget /cxsjjh/out/1201/green/$v_date/001/1201_PAYMENT_DUE_1YEAR_T*.txt
    	mget /cxsjjh/out/1201/green/$v_date/001/1201*.ok
   	  exit;
EOF
```

### 6、判断文件是否存在

```Shell
 d=`find 文件存放的地址 -type f | wc -l `若存在，则$d=1
 如：    
 d=`find $v_data_file/1201_PAYMENT_DUE_1YEAR_T*.txt -type f | wc -l`
```

### 7、for循环

-  第一类：数字性循环

  - 方法一

    ```shell
    #!/bin/bash   
    for((i=1;i<=10;i++));  
    do   
    echo $(expr $i \* 3 + 1);  
    done  
    ```

  - 方法二

    ```Shell 
    #!/bin/bash  
    for i in $(seq 1 10)  
    do   
    echo $(expr $i \* 3 + 1);  
    done  
    ```

  - 方法三

    ```shell
    #!/bin/bash  
    for i in {1..10}  
    do  
    echo $(expr $i \* 3 + 1);  
    done  
    ```

  - 方法四

    ```shell
    #!/bin/bash  
    awk 'BEGIN{for(i=1; i<=10; i++) print i}'  
    ```

- 第二类：字符性循环

   - 方法一

     ```shell
     #!/bin/bash  
     for i in `ls`;  
     do   
     echo $i is file name\! ;  
     done  
     ```

   - 方法二

     ```shell
     #!/bin/bash  
     for i in $* ;  
     do  
     echo $i is input chart\! ;  
     done 
     ```

   - 方法三

     ```shell
     #!/bin/bash  
     for i in f1 f2 f3 ;  
     do  
     echo $i is appoint ;  
     done  
     ```

   - 方法四

     ```Shell
     #!/bin/bash    
     list="rootfs usr data data2"  
     for i in $list;  
     do  
     echo $i is appoint ;  
     done  
     ```

- 第三类：路径查找

  - 方法一

    ```shell
    #!/bin/bash  
    for file in /proc/*;  
    do  
    echo $file is file path \! ;  
    done  
    ```

  - 方法二

    ```shell
    #!/bin/bash   
    for file in $(ls *.sh)  
    do  
    echo $file is file path \! ;  
    done 
    ```

### 8、连接oracle数据库

~~~shell
#配置oracle环境变量
##ORACLE_HOME=存放oracle客户端的地址
如：ORACLE_HOME=/app/oracle/product/dbclt11gr2
##TNS_ADMIN确认使用哪个oracle产品
如：TNS_ADMIN=$ORACLE_HOME
##NLS_LANG是一个环境变量，用于定义语言，地域以及字符集属性。
NLS_LANG=AMERICAN_AMERICA.UTF8  
##PATH=可执行程序的查找路径即sqlplus命令的处理程序存放的地址,一般存放在oracle安装目录下的$ORACLE_HOME\BIN目录中
如：PATH=$ORACLE_HOME/bin:$PATH
#LD_LIBRARY_PATH=动态库的查找路径
LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
##export:功能说明：设置或显示环境变量。(把本地变量变成全局变量)
export NLS_LANG ORACLE_HOME PATH LD_LIBRARY_PATH
#数据库配置(登录数据库)
DBALIAS=用户名/密码@主机名:端口号/数据库名
如：DBALIAS=amsapp/Ams1234@10.186.26.170:1521/amsdb
#存储过程
v_data_pro=ams_datalanding_pkg.ams_yaerdue_porc
~~~

### 9、shell与sqlplus交互

- Sqlplus无返回值

  ~~~shell
  #数据库配置(登录数据库)
  DBALIAS=用户名/密码@主机名:端口号/数据库名
  sqlplus -s $DBALIAS<<EOF
  set heading off;
  set feedback off;
  set pagesize 0;
  set verify off;
  set echo off;
  	##新增语句##
  exit;
  EOF
  ~~~


- sqlplus有返回值

  ~~~shell
  #数据库配置(登录数据库)
  DBALIAS=用户名/密码@主机名:端口号/数据库名
  v_date=`sqlplus -s $DBALIAS<<EOF
  set echo off;
  set linesize 999;
  set term off;
  set head off;
  set feedback off;
  set trimspool on;
  set pagesize 0;
  	##查询语句##
  exit;
  EOF`
  ~~~

 ###  10、解析文件

```shell
#数据库配置(登录数据库)
DBALIAS=用户名/密码@主机名:端口号/数据库名
sqlldr $DBALIAS 
control=存放数据库字段要与解析文件字段匹配的ctl文件的地址 
log=存放解析文件日志的地址
bad=若该文件解析错误后存放文件的地址 
data=存放解析文件的地址 
errors=容错数

sqlldr $DBALIAS control=$fileProfix/ctl/PAYMENT_DUE_1YEAR_T.ctl log=$v_data_log/PAYMENT_DUE_1YEAR_T.log bad=$v_data_bad/$badName.bad data=$FILE errors=50000 > /dev/null

```





​	 
