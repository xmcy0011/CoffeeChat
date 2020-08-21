# ====================== 自定义宏 产品信息==============================
!define PRODUCT_NAME           		"CoffeeChat"
!define PRODUCT_PATHNAME 			"CIM_PC"  #安装卸载项用到的KEY
!define INSTALL_APPEND_PATH         "CIM"	  #安装路径追加的名称 
!define INSTALL_DEFALT_SETUPPATH    ""        #默认生成的安装路径  
!define EXE_NAME               		"CoffeeChat.exe"
!define PRODUCT_VERSION        		"0.1.0.0"
!define PRODUCT_PUBLISHER      		"CoffeeChat"
!define PRODUCT_LEGAL          		"CoffeeChat Copyright（c）2015"
!define INSTALL_OUTPUT_NAME    		"CIM_PC_Setup_v0.1.0.exe"

# ====================== 自定义宏 安装信息==============================
!define INSTALL_7Z_PATH 	   		"..\app.7z"
!define INSTALL_7Z_NAME 	   		"app.7z"
!define INSTALL_RES_PATH       		"skin.zip"
!define INSTALL_LICENCE_FILENAME    "licence.rtf"
!define INSTALL_ICO 				"logo.ico"
!define UNINSTALL_ICO 				"uninst.ico"

#SetCompressor lzma

!include "ui_cim_setup.nsh"

# ==================== NSIS属性 ================================

# 针对Vista和win7 的UAC进行权限请求.
# RequestExecutionLevel none|user|highest|admin
RequestExecutionLevel admin


; 安装包名字.
Name "${PRODUCT_NAME}"

# 安装程序文件名.

OutFile "..\..\Output\${INSTALL_OUTPUT_NAME}"

;$PROGRAMFILES32\Netease\NIM\

InstallDir "1"

# 安装和卸载程序图标
Icon              "${INSTALL_ICO}"
UninstallIcon     "${UNINSTALL_ICO}"
