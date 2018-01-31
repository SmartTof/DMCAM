#TOFSDK使用说明
***
##TOFSDK简介
TOFSDK适配于数迹智能科技有限公司的的TCM_E1和TCM_E2系列模组，用于深度、灰度等视觉数据开发，TOFSDK主要包含以下主要模块。
| 模块名称    |     模块功能     |
| :------ | :----------: |
| DMCAM   | 提供相关库、头文件和例程 |
| doc     |  一些相关的文档说明   |
| Drivers |   设备的usb驱动   |
| Tools   | 相关GUI和命令行工具  |
TOFSDK可在多种操作系统运行，支持多种编程语言,在DMCAM模块中有相应的测试样例提供参考，便于用户熟悉相关API及使用方法来快速进行二次开发，下表列出了TOFSDK的一些特性。

| 系统        | C/C++     | python    | android     | matlab/c# |
| :-------- | :-------- | :-------- | :---------- | :-------- |
| windows7  | ROS 样例    | Opencv 样例 | android apk | API使用样例   |
| windows10 | Opencv 样例 | VTK 样例    |             |           |
| ubuntu14  | OpenNI 样例 | PCL 样例    |             |           |
| ubuntu16  |           |           |             |           |
***
##SDK的使用
- 在对应的操作系统下进行相应的的环境配置
- 安装模组的usb驱动
- 相关API介绍和样例说明
***

##系统使用环境配置方法
###windows下配置
- 环境：win10 64位, msys2 32/64位
- 配置
1. 从官网下载msys2（这里安装的是 msys2-i686- 开头的32位）并按照官网教程安装

2. 在msys2安装gcc，gdb，make几个相关的包
  pacman -S msys/make
  pacman -S msys/gcc
3. 分别安装不同版本的对应包
>若打开使用mingw32.exe，则分别运行
	pacman -S mingw32/mingw-w64-i686-gcc
	pacman -S mingw32/mingw-w64-i686-gdb
	pacman -S mingw32/mingw-w64-i686-make
>若打开使用mingw64.exe，则分别运行
	pacman -S mingw32/mingw-w64-x86_64-gcc
	pacman -S mingw32/mingw-w64-x86_64-gdb
	pacman -S mingw32/mingw-w64-x86_64-make
4. 安装USB驱动
  双击SDK中drivers\usb_driver目录下面的install_driver.bat文件，进行USB驱动安装。
5. 测试运行
>在SDK里的DMCAM\Windows\samples\c文件夹下的CMakeList.txt 所在目录建立文件夹build， 打开msys2编译相应工程。
	1$ cd build
	2$ cmake .. -G "MSYS Makefiles"   //第一次cmake失败可以再尝试一次
	3$ make -j  //or mingw32-make
	在build目录下有相应的sample开头的.exe格式的可执行文件生成
***
###linux下环境配置
- 环境：Ubuntu 14.04/16.04 64位
- 配置：
1. 安装cmake，打开终端，输入安装命令
  sudo apt-get install cmake

  因为ubuntu14和ubuntu16下的libusb驱动自带，这里不用额外再装
2. 测试运行
> 在DMCAM\linux\samples\c文件夹下的CMakeList.txt 所在目录建立文件夹build， 打开终端编译相应工程。
	1$ cd build
	2$ cmake .. -G "Unix Makefiles"
	3$ make -j
> 在build目录下有对应的sample开头的可执行文件生成
***
###相关样例说明
在DMCAM文件夹下含有windows和linux两个子文件夹，里面的sample提供有C、python等样例，运行样例的相关步骤说明参考对应的readme.md。
####C样例简介
C/C++样例位于sample下的c文件夹中，主要展示对设备的连接，设置参数，读取数据等操作。
###python样例简介
python样例位于sample下的python文件夹中，通过运行相关python样例，除了基本的设备操作外，可以动态显示采集的数据。
###ros样例简介
ros样例位于linux下的sample中，主要展示如何在ros下对模组设备进行相关的操作。
###java样例简介
java样例主要提供或者生成java下的相关接口，方便进行Android等开发使用。
***
##API说明
SDK中所用的相关结构体定义和函数声明都位于lib\include文件夹下的dmcam.h中，例如windows下则在DMCAM\Windows\lib\include下，函数的主要功能和具体参数介绍在dmcam.h中有详细介绍。
***
##主要操作说明
- 进行设备的连接,下面是显示打开连接设备的主要代码
~~~
dmcam_init(NULL);	//初始化
int dev_cnt;
dev_cnt = dmcam_dev_list(dev_list,4); //显示所有连接的设备
if(dev_cnt!=0)
{
  dev = dmcam_dev_open(&dev_list[0]); //打开第一个设备
}
~~~
***
- 进行设备参数的设置，下面代码展示设置一个功率参数
~~~
wparam.param_id = PARAM_ILLUM_POWER;	//设置参数为功率wparam.param_val_len = 1;
wparam.param_val.raw[0] = 30;			//功率大小为30
assert(dmcam_param_batch_set(dev, &wparam, 1));	//调用dmcam_param_batch_set()函数来设置
~~~
- 采集数据时，下面是采集数据的主要代码
~~~ 
dmcam_cap_set_frame_buffer(dev,NULL,FRAME_SIZE*FRAME_BUF_FCNT);
dmcam_cap_set_callback_on_error(dev,on_cap_err);//设置采集时的错误回调
dmcam_cap_set_callback_on_frame_ready(dev,NULL);//禁止采集完一帧的回调
dmcam_cap_start(dev);//开始采集
fr_cnt = dmcam_cap_get_frames(dev,20,fbuf,FRAME_SIZE*20,&fbuf_info);//采集20帧数据
dmcam_frame_get_distance(dev,dist,dist_len,fbuf,fbuf_info.frame_info.frame_size,&fbuf_info.frame_info);//解析出一帧深度数据
dmcam_frame_get_gray(dev,gray,gray_len,fbuf,fbuf_info.frame_info.frame_size,&fbuf_info.frame_info);//解析出一帧灰度数据
dmcam_cap_stop(dev);//停止采集
~~~
***
上面是设备的主要操作，具体可见相关的样例使用说明，如sample_set_param.c 展示设置和获取设备信息，sample_filter.c展示相机校准相关的功能。