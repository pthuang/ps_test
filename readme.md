# GIT管理FPGA工程

>   此工程是学习Vitis的例子工程，基于xc7z035ffg900-2建立Vivado工程，包含ARM和Microbalze的BlockDesign，在此基础上进行Vitis开发；



## 1.仓库管理



### 1.1 Git项目管理须知



### 1.2 FPGA工程管理





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
    +   修改*axi_bridge.v*读写地址逻辑；

+   仓库运维环境相关

    +   BUG0已解决，**xsa**还是会更新；
    
    +   BUG1不是问题，临时文件不能删除，否则无法恢复工程；
    
        导出**platform**的时候需要用到top模块名，优化代码为下面这句，打开工程后可获取top模块名：
    
        ```tcl
        get_property top [current_fileset]
        ```
    
    +   新建*writeBD2Tcl.tcl*文件，暂时还未写好，用于更新**BlockDesign**文件；
    
    +   
    
    
