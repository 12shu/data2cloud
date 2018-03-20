
# data2cloud
环境要求：
Windows10

组件要求：
激活win10内置Ubuntu

涉及工具：
rclone(rclone.org)

推荐云存储：www.backblaze.com
也叫b2云存储

理由：
存储$0.005/G/月
下载$0.01/G/月

主要实现功能：
定时增量上传/下载数据，进而实现数据同步和备份

第一步：

启用win10内置的Linux

1.进入控制面板

2.点“程序”

3.点“启用或关闭Windows功能”

4.找到“适用于Linux的Windows子系统（Beta)

由未勾选变成勾选状态，然后完成安装后重启电脑。

第二步：

打开Microsoft Store，搜”Ubuntu“并且安装

第三步：

安装好以后启动，启动完自动弹出窗口，并等待安装。

第四步：

安装完以后，会让提示设置账户，输入root

输入完以后，会提示输入密码，输入两遍，完成后 就进入了命令行界面。

第五步：

依次输入每一行并回车

apt-get install unzip

curl https://rclone.org/install.sh | sudo bash

完成安装后，

输入rclone config然后回车，在第一个提示输入n，然后回车

No remotes found - make a new one
n) New remote
s) Set configuration password
q) Quit config
n/s/q> n

然后设置名字：

name>

输入完名字后回车，回车后选择存储端类型（建议选3，也就是b2存储），

Type of storage to configure.
Choose a number from below, or type in your own value

b2存储可以进入www.backblaze.com注册，并且获得ID和KEY，同时创建个bucket，记住名字

英文是”Show Account ID and Application Key“

中文是”露出账目身份证和应用软件钥匙“

选择存储类型后续回车



回车依次输入ID和KEY并回车，然后会提示endpoint，默认回车。

回车完毕后会提示如下内容，输入Y并回车：

--------------------
y) Yes this is OK
e) Edit this remote
d) Delete this remote
y/e/d> y

回车完毕后提示如下内容，输入q并回车

Current remotes:

Name Type
==== ====
remote b2

e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q> q

至此，就搞定了。

接下来，就是设置定时任务

输入touch down.sh

然后vim down.sh

按i然后输入rclone copy 前面设置的名字:b2的bucket名字 /mnt/你要同步的目录

然后按ESC，输入:wq

同样，

输入touch up.sh

然后vim up.sh

按i然后输入rclone copy /mnt/你要同步的目录 前面设置的名字:b2的bucket名字

然后按ESC，输入:wq

设置完以后chmod 777 down.sh

和chmod 777 up.sh

完事之后，输入crontab -e

第一次用会让你选编辑器，选3

然后进入编辑状态，

输入*/10 * * * * bash /root/down.sh

然后输入*/5 * * * * bash /root/up.sh

以上内容是每5分钟增量上传一次，每10分钟，增量下载一次。

然后再新建一个开机挂起脚本

touch boot.sh

然后vim boot.sh

按i然后输入

#!/bin/sh
service cron restart

sh /root/down.sh

sh /root/up.sh

$SHELL

然后按ESC，并且输入:wq回车

回车完以后输入chmod 777 boot.sh然后回车

回车后要重启cron任务，输入service cron restart并回车

如果你希望开机自启，就继续看下面的内容，不然就可以直接忽略啦，每次需要的时候，打开这个Ubuntu，然后执行sh /root/boot.sh就可以了

也可以考虑按照下面教程创建vbs脚本，但是不设置计划任务。

完成后在你本地PC端找个目录，

创建vbs脚本(D:\wsl.vbs)

Set ws = CreateObject("Wscript.Shell") 
ws.run "bash /root/boot.sh",vbhide
输入以上2行内容

完事保存。

说明：这里通过 vbs脚本在后台打开一个 bash.exe 来保证bash进程一直开着。当然，还可以通过Windows的计划任务实现开机启动WSL并打开其中的程序。

在win10打开计划任务，设置开机执行这个vbs脚本即可。

至此就完成了全部设置。。
