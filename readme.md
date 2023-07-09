# GIT管理FPGA工程

>   此工程是学习Vitis的例子工程，基于xc7z035ffg900-2建立Vivado2019.2工程，包含ARM和Microbalze的BlockDesign，在此基础上进行Vitis开发；



## 1.仓库管理



### 1.1 Git管理须知

+   为什么使用git管理Vivado工程？

    **本人的初衷是一为了节省硬盘空间，二是为了降低使用门槛。**

    只使用git来备份必要的文件，比如ip?只要**.xci**文件；BlockDesign?导出成**.tcl**脚本，Vivado工程？导出成**.tcl**脚本，Vitis相关？只要**.xsa/.c/.h**；从而达到节省硬盘空间的目的；

    但是这些文件，有些是源文件，有些呢是中间文件，在这个过程中有大量的转换、导出等操作，这样的话学习并且使用这个流程的成本就会变得太高了，这样会导致没用过它的人望而却步！

    万幸Vivado中继承了TCL解释器，这样借助tcl，我们能做的东西就很多了，经过多次开发调试与迭代，这样一个使用windows批处理打开Vivado，使用tcl脚本自动化实现Vivado中各种文件类型转换的一个git版本控制方法就诞生了。

    

+   使用git管理有什么**特点**

    >   以下所有观点说的是本人使用的这种管理方式

    1.   先说**优点**，最最明显的，节省硬盘空间，节省90%以上的硬盘空间，工程越大，节省的越多。

         不妨在第一次git拉取后先看下工程的大小，然后等你跑完bit再看一下工程的大小。

         其他git本身带来的优势这里按下不表。

    2.   有没有**缺点**？也有。

         由于git中只加入了Vivado的设计输入（rtl，ip，bd，xdc，ip library，c代码等等）和必要的结果输出（bit，ltx，xsa/hdf等等），所以**综合/实现阶段的各种报告肯定是没法查看**了，要查看只能再跑一次，所以就**比较费时间**，如果电脑配置好，工程不大，或者只需要bit等上板调试的情况下就无所谓了。

         另外在恢复工程后

    3.   另外还有一些**限制**，比如如果你的设计中对某些ip内部的源码进行了修改，那可能需要一些特别的处理，单纯的傻瓜式操作（双击bat）就无法胜任了。

+   如何使用此仓库？

    **注意，以下所有的操作均是在windows开发环境下进行，使用linux的不妨先耐心理解一下整个管理的方法和过程，之后就可以正常使用了！**

    第一次拉取仓库后，须将*/map/vivado_bat_templete/*路径下的下的两个txt文件复制到/map/路径下，然后将后缀名改为**.bat**，即windows批处理文件，然后**先别急着**双击运行。

    改完后缀名之后，这两个文件的名字为*auto_recover_xpr.bat，autoSyncBeforeCommit.bat*，从名字上不难看出其作用，一个用于git拉取后恢复Vivado工程，另一个用于git提交前同步，那么这个同步到底是个什么概念呢？这个容后再说。

    以*auto_recover_xpr.bat*为例，其内容如下：

    ```shell
    path %psth%;C:\Xilinx\Vivado\2019.2\bin
    @echo off 
    color 0A
    echo ***************************************************
    echo *
    echo *
    echo *          Welcome to Vivado 2019.2
    echo * Do not close this window before closing Vivado
    echo *
    echo *
    echo *
    echo ***************************************************
    
    vivado -mode tcl -source ./tcl/recover_xpr.tcl
    ```
    1. 先把第一行代码的路径改成你自己电脑上Vivado的安装路径，注意要改的是*/map/*下的**bat**文件，比如你的安装在D盘，那就改成：
    
    ```shell
    path %psth%;D:\Xilinx\Vivado\2019.2\bin
    ```
    
    2.   改完之后就可以双击运行了，另一个bat文件也要改；
    
    3.   上述代码的作用其实就是找到Vivado的安装路径，然后使用**Vivado Tcl Shell**来执行路径./tcl/下的recover_xpr.tcl脚本，如果去掉-mode tcl的话（不建议）它会先打开Vivado GUI然后在GUI下运行后面的tcl脚本，我这里采用的方式都是先执行代码，最后一步才会打开GUI给用户查看，有兴趣的可以去看recover_xpr.tcl这个文件的最后一行代码。
    
    4.   日常使用过程中，记住两点，git拉取后，一定要恢复工程（双击*auto_recover_xpr.bat*），git提交前，一定要进行同步（双击*autoSyncBeforeCommit.bat*）；
    
         注意恢复的时候，如果本地已经有工程了，记得先删除（/map/下的整个工程文件夹，如这里的ps_test），不然它就没法恢复，会直接打开本地存在的工程（**但不是最新的**）。











### 1.2 FPGA工程管理

**注意FPGA工程使用的版本是Vivado2019.2，使用别的版本可能会导致工程恢复出错！**



### 1.3 Vitis工程管理

>   Vitis是Xilinx的软件开发工具，以前叫做SDK，从Vivado2019开始升级成Xilinx Vitis，后面改成了AMD Vitis；









## 2.项目介绍

















## 3.迭代日志

### 之前：

+   没写，懒......
+   开发还不完善，没什么好写的；
+   实在想看去查git log;

### 2023.07.07 modify log:

+   项目相关

    +   串口功能已调试完成；
    +   AXI_GPIO中断调试完成，然而经权衡觉得并不好用；

    +   AXI4-lite接口（MB与逻辑侧通信）正在调试中；

+   仓库运维环境相关

    +   BUG0

        +   现象描述：调整了*flowCtrol.tcl*中导出platform文件(**xsa/hdf**)文件的顺序后，在本地仓库拉取后执行*autoSyncBeforeCommit.bat*时出错。此次调整主要是想要改善xsa文件频繁更新的问题，如果**MicroBlaze BD**文件根本没有任何修改，则没有必要更新**xsa**文件，但是放到最后一步的话每次仓库提交**xsa**文件都会更新，这显然不是我们想要的；

            >   ERROR: [Vivado_Tcl 4-427] Hardware Handoff file cannot be generated as Block Diagram D:/.../src/ip/clk_gen/

        +   原因分析：根据报错信号，是由于top层下有**ip**没有完成综合，所以导出**xsa**失败，将该**ip**综合完成后，再次尝试该流程，成功导出xsa。

        +   解决方向：问题的关键在于如何知道所有ip是否综合完成？如果部分/全部ip没有综合完成，应先进行综合，然后再导出xsa文件；

            或者还有一个办法，将所有ip的综合方式改成Global，不过这样的话跑bit的时间就会变长。。。有利有弊，待后分析！

        +   备注：**BUG解决后不要忘记验证xsa文件是否还频繁更新！！！**

    +   BUG1
    
        +   现象描述：map/tcl/下的部分源文件列表（.txt）文件总是频繁更新；
        +   原因分析：不同设备下仓库的路径不同；
        +   解决方向：这些其实都是临时文件，后续可以考虑使用完设之后直接删除；

### 2023.07.08 modify log:

+   项目相关

    +   AXI4-lite接口读写时序正确，地址还不对；
    +   修改*axi_bridge.v*读写地址逻辑后读写还是不对，应该是跨时钟域问题，待后分析；

+   仓库运维环境相关

    +   BUG0已解决，**xsa**还是会更新；
    
    +   BUG1不是问题，临时文件不能删除，否则无法恢复工程；
    
        导出**platform**的时候需要用到top模块名，优化代码为下面这句，打开工程后可获取top模块名：
    
        ```tcl
        get_property top [current_fileset]
        ```
    
    +   新建*writeBD2Tcl.tcl*文件，暂时还未写好，用于更新**BlockDesign**文件；
    

### 2023.07.09 modify log:

+   项目相关
    +   修改*axi_bridge.v*跨时钟域相关逻辑；
    +   添加vio抓取axi对应的读写寄存器；
+   仓库运维环境相关
    +   *writeBD2Tcl.tcl*代码已完成，经测试，只要BD没有修改，重新导出的tcl脚本内容也不会变化；
