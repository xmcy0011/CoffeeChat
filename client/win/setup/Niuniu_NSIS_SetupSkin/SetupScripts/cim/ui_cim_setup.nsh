
# ===================== 外部插件以及宏 =============================
!include "StrFunc.nsh"
!include "WordFunc.nsh"
${StrRep}
${StrStr}
!include "LogicLib.nsh"
!include "nsDialogs.nsh"
!include "common.nsh"
!include "x64.nsh"
!include "MUI.nsh"
!include "WinVer.nsh" 
!include "..\commonfunc.nsh"

!insertmacro MUI_LANGUAGE "SimpChinese"
# ===================== 安装包版本 =============================
VIProductVersion             		"${PRODUCT_VERSION}"
VIAddVersionKey "ProductVersion"    "${PRODUCT_VERSION}"
VIAddVersionKey "ProductName"       "${PRODUCT_NAME}"
VIAddVersionKey "CompanyName"       "${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileVersion"       "${PRODUCT_VERSION}"
VIAddVersionKey "InternalName"      "${EXE_NAME}"
VIAddVersionKey "FileDescription"   "${PRODUCT_NAME}"
VIAddVersionKey "LegalCopyright"    "${PRODUCT_LEGAL}"

!define INSTALL_PAGE_CONFIG 			0
;!define INSTALL_PAGE_LICENSE 			1
!define INSTALL_PAGE_PROCESSING 		1
!define INSTALL_PAGE_FINISH 			2
!define INSTALL_PAGE_UNISTCONFIG 		3
!define INSTALL_PAGE_UNISTPROCESSING 		4
!define INSTALL_PAGE_UNISTFINISH 		5

# 自定义页面
Page custom DUIPage

# 卸载程序显示进度
UninstPage custom un.DUIPage

# ======================= DUILIB 自定义页面 =========================
Var hInstallDlg
Var hInstallSubDlg
Var sCmdFlag
Var sCmdSetupPath
Var sSetupPath 
Var sReserveData   #卸载时是否保留数据 
Var InstallState   #是在安装中还是安装完成  
Var UnInstallValue  #卸载的进度  

Var temp11
Var temp12
Function DUIPage
    StrCpy $InstallState "0"	#设置未安装完成状态
	InitPluginsDir   	
	SetOutPath "$PLUGINSDIR"
	File "${INSTALL_LICENCE_FILENAME}"
    File "${INSTALL_RES_PATH}"
	File /oname=logo.ico "${INSTALL_ICO}" 		#此处的目标文件一定是logo.ico，否则控件将找不到文件 
	nsNiuniuSkin::InitSkinPage "$PLUGINSDIR\" "${INSTALL_LICENCE_FILENAME}" #指定插件路径及协议文件名称
    Pop $hInstallDlg
   	
	#生成安装路径，包含识别旧的安装路径  
    Call GenerateSetupAddress
	
	#设置控件显示安装路径 
    nsNiuniuSkin::SetControlAttribute $hInstallDlg "editDir" "text" "$INSTDIR\"
	Call OnRichEditTextChange
	#设置安装包的标题及任务栏显示  
	nsNiuniuSkin::SetWindowTile $hInstallDlg "${PRODUCT_NAME}安装程序"
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_CONFIG}
	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "licensename" "text" "CoffeeChat服务条款"
	#nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnAgreement" "text" "  用户许可协议"
		
    Call BindUIControls	
    nsNiuniuSkin::ShowPage 0	
FunctionEnd

Function un.DUIPage
	StrCpy $InstallState "0"
    InitPluginsDir
	SetOutPath "$PLUGINSDIR"
    File "${INSTALL_RES_PATH}"
	File /oname=logo.ico "${UNINSTALL_ICO}" 		#此处的目标文件一定是logo.ico，否则控件将找不到文件 
	nsNiuniuSkin::InitSkinPage "$PLUGINSDIR\" "" 
    Pop $hInstallDlg
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_UNISTCONFIG}
	#设置安装包的标题及任务栏显示  
	nsNiuniuSkin::SetWindowTile $hInstallDlg "${PRODUCT_NAME}卸载程序"
	nsNiuniuSkin::SetWindowSize $hInstallDlg 480 390
	Call un.BindUnInstUIControls
	
	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "chkAutoRun" "selected" "true"
	
    nsNiuniuSkin::ShowPage 0
	
FunctionEnd

#绑定卸载的事件 
Function un.BindUnInstUIControls
	GetFunctionAddress $0 un.ExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnUninstalled" $0
	
	GetFunctionAddress $0 un.onUninstall
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnUnInstall" $0
	
	GetFunctionAddress $0 un.ExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnClose" $0
FunctionEnd

#绑定安装的界面事件 
Function BindUIControls
	# License页面
    GetFunctionAddress $0 OnExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnLicenseClose" $0
    
    GetFunctionAddress $0 OnBtnMin
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnLicenseMin" $0
    
	
	GetFunctionAddress $0 OnBtnLicenseClick
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnAgreement" $0
	
    # 目录选择 页面
    GetFunctionAddress $0 OnExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnDirClose" $0
	
	GetFunctionAddress $0 OnExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnLicenseCancel" $0
    
    GetFunctionAddress $0 OnBtnMin
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnDirMin" $0
    
    GetFunctionAddress $0 OnBtnSelectDir
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnSelectDir" $0
    
    GetFunctionAddress $0 OnBtnDirPre
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnDirPre" $0
    
	GetFunctionAddress $0 OnBtnShowConfig
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnAgree" $0
	
    GetFunctionAddress $0 OnBtnCancel
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnDirCancel" $0
        
    GetFunctionAddress $0 OnBtnInstall
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnInstall" $0
    
    # 安装进度 页面
    GetFunctionAddress $0 OnExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnDetailClose" $0
    
    GetFunctionAddress $0 OnBtnMin
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnDetailMin" $0

    # 安装完成 页面
    GetFunctionAddress $0 OnFinished
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnRun" $0
    
    GetFunctionAddress $0 OnBtnMin
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnFinishedMin" $0
    
    GetFunctionAddress $0 OnExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnClose" $0
	
	GetFunctionAddress $0 OnCheckLicenseClick
    nsNiuniuSkin::BindCallBack $hInstallDlg "chkAgree" $0
	
	GetFunctionAddress $0 OnBtnShowMore
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnShowMore" $0
	
	GetFunctionAddress $0 OnBtnHideMore
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnHideMore" $0
	
	#绑定窗口通过alt+f4等方式关闭时的通知事件 
	GetFunctionAddress $0 OnSysCommandCloseEvent
    nsNiuniuSkin::BindCallBack $hInstallDlg "syscommandclose" $0
	
	#绑定路径变化的通知事件 
	GetFunctionAddress $0 OnRichEditTextChange
    nsNiuniuSkin::BindCallBack $hInstallDlg "editDir" $0
FunctionEnd

#此处是路径变化时的事件通知 
Function OnRichEditTextChange
	#可在此获取路径，判断是否合法等处理 
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "editDir" "text"
    Pop $0	
	StrCpy $INSTDIR "$0"
	
	Call IsSetupPathIlleagal
	${If} $R5 == "0"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "local_space" "text" "路径非法"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "local_space" "textcolor" "#ffff0000"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnInstall" "enabled" "false"
		goto TextChangeAbort
    ${EndIf}
	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "local_space" "textcolor" "#FF999999"
	${If} $R0 > 1024                               #400即程序安装后需要占用的实际空间，单位：MB  
	    
		IntOp $R1  $R0 % 1024	
		IntOp $R0  $R0 / 1024;		
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "local_space" "text" "剩余空间：$R0.$R1GB"
	${Else}
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "local_space" "text" "剩余空间：$R0.$R1MB"
     ${endif}
	
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkAgree" "selected"
    Pop $0
	${If} $0 == "1"        
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnInstall" "enabled" "true"
	${Else}
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnInstall" "enabled" "false"
    ${EndIf}
	
TextChangeAbort:
FunctionEnd


#根据选中的情况来控制按钮是否灰度显示 
Function OnCheckLicenseClick
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkAgree" "selected"
    Pop $0
	${If} $0 == "0"        
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnInstall" "enabled" "true"
	${Else}
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnInstall" "enabled" "false"
    ${EndIf}
FunctionEnd

Function OnBtnLicenseClick
    ;nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_LICENSE}
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "licenseshow" "visible" "true"
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "moreconfiginfo" "visible"
	Pop $0
	${If} $0 = 0        
		;pos="10,35,560,405"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "licenseshow" "pos" "5,35,475,385"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "editLicense" "height" "270"		
	${Else}
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "licenseshow" "pos" "5,35,475,495"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "editLicense" "height" "375"
    ${EndIf}
	
FunctionEnd

# 添加一个静默安装的入口
Section "silentInstallSec" SEC01
    #MessageBox MB_OK|MB_ICONINFORMATION "Test silent install. you can add your silent install code here."
SectionEnd

Function ShowMsgBox
	nsNiuniuSkin::InitSkinSubPage "msgBox.xml" "btnOK" "btnCancel,btnClose"  ; "提示" "${PRODUCT_NAME} 正在运行，请退出后重试!" 0
	Pop $hInstallSubDlg
	nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "lblTitle" "text" "提示"
	nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "lblMsg" "text" "$R8"
	${If} "$R7" == "1"
		nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "hlCancel" "visible" "true"
	${EndIf}
	
	nsNiuniuSkin::ShowSkinSubPage 0 
FunctionEnd

# 开始安装
Function OnBtnInstall
    nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkAgree" "selected"
    Pop $0
	StrCpy $0 "1"
		
	#如果未同意，直接退出 
	StrCmp $0 "0" InstallAbort 0
	
	#此处检测当前是否有程序正在运行，如果正在运行，提示先卸载再安装 
	nsProcess::_FindProcess "${EXE_NAME}"
	Pop $R0
	
	${If} $R0 == 0
        StrCpy $R8 "${PRODUCT_NAME} 正在运行，请退出后重试!"
		StrCpy $R7 "0"
		Call ShowMsgBox
		goto InstallAbort
    ${EndIf}		

	nsNiuniuSkin::GetControlAttribute $hInstallDlg "editDir" "text"
    Pop $0
    StrCmp $0 "" InstallAbort 0
	
	#校正路径（追加）  
	Call AdjustInstallPath
	StrCpy $sSetupPath "$INSTDIR"	
	
	Call IsSetupPathIlleagal
	${If} $R5 == "0"
		StrCpy $R8 "路径非法，请使用正确的路径安装!"
		StrCpy $R7 "0"
		Call ShowMsgBox
		goto InstallAbort
    ${EndIf}	
	${If} $R5 == "-1"
		StrCpy $R8 "目标磁盘空间不足，请使用其他的磁盘安装!"
		StrCpy $R7 "0"
		Call ShowMsgBox
		goto InstallAbort
    ${EndIf}
	
	
	nsNiuniuSkin::SetWindowSize $hInstallDlg 480 390
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnClose" "enabled" "false"
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_PROCESSING}
    
    nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrProgress" "min" "0"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrProgress" "max" "100"
	
    # 将这些文件暂存到临时目录
    #Call BakFiles
    
    #启动一个低优先级的后台线程
    GetFunctionAddress $0 ExtractFunc
    BgWorker::CallAndWait
	
    
	#根据复选框的值来决定是否添加桌面快捷方式  
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkShotcut" "selected"
	Pop $R0	
	${If} $R0 == "1"	
		#添加到桌面快捷方式的动作 在此添加  
		SetShellVarContext all
		CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}"	
		SetShellVarContext current	
	${EndIf}
	
	Call CreateAppShortcut
	Call CreateUninstall
    
			
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnClose" "enabled" "true"		
	StrCpy $InstallState "1"
	#如果不想完成立即启动的话，需要屏蔽下面的OnFinished的调用，并且打开显示INSTALL_PAGE_FINISH
	#Call OnFinished
	#以下这行如果打开，则是跳转到完成页面 
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_FINISH}
InstallAbort:
FunctionEnd

Function ExtractCallback
    Pop $1
    Pop $2
    System::Int64Op $1 * 100
    Pop $3
    System::Int64Op $3 / $2
    Pop $0
	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrProgress" "value" "$0"	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_pos" "text" "$0%"
    ${If} $1 == $2  
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrProgress" "value" "100"	
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_pos" "text" "100%"
    ${EndIf}
FunctionEnd

#CTRL+F4关闭时的事件通知 
Function OnSysCommandCloseEvent
	Call OnExitDUISetup
FunctionEnd

#安装界面点击退出，给出提示 
Function OnExitDUISetup
	${If} $InstallState == "0"		
		StrCpy $R8 "安装尚未完成，您确定退出安装么？"
		StrCpy $R7 "1"
		Call ShowMsgBox
		pop $0
		${If} $0 == 0
			goto endfun
		${EndIf}
	${EndIf}
	nsNiuniuSkin::ExitDUISetup
endfun:    
FunctionEnd

Function OnBtnMin
    SendMessage $hInstallDlg ${WM_SYSCOMMAND} 0xF020 0
FunctionEnd

Function OnBtnCancel
	nsNiuniuSkin::ExitDUISetup
FunctionEnd

Function OnFinished	
		    
	#立即启动
    Exec "$INSTDIR\${EXE_NAME}"
    Call OnExitDUISetup
FunctionEnd

Function OnBtnSelectDir
    nsNiuniuSkin::SelectInstallDirEx $hInstallDlg "请选择安装路径"
    Pop $0
	${Unless} "$0" == ""
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "editDir" "text" $0
	${EndUnless}
FunctionEnd

Function StepHeightSizeAsc
${ForEach} $R0 390 500 + 10
  nsNiuniuSkin::SetWindowSize $hInstallDlg 480 $R0
  Sleep 5
${Next}
FunctionEnd

Function StepHeightSizeDsc
${ForEach} $R0 480 390 - 10
  nsNiuniuSkin::SetWindowSize $hInstallDlg 480 $R0
  Sleep 5
${Next}
FunctionEnd

Function OnBtnShowMore	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnShowMore" "enabled" "false"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnHideMore" "enabled" "false"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "moreconfiginfo" "visible" "true"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnHideMore" "visible" "true"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnShowMore" "visible" "false"
	;调整窗口高度 
	 GetFunctionAddress $0 StepHeightSizeAsc
    BgWorker::CallAndWait
	
	nsNiuniuSkin::SetWindowSize $hInstallDlg 480 500
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnShowMore" "enabled" "true"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnHideMore" "enabled" "true"
FunctionEnd

Function OnBtnHideMore
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnShowMore" "enabled" "false"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnHideMore" "enabled" "false"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "moreconfiginfo" "visible" "false"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnHideMore" "visible" "false"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnShowMore" "visible" "true"
	;调整窗口高度 
	 GetFunctionAddress $0 StepHeightSizeDsc
    BgWorker::CallAndWait
	nsNiuniuSkin::SetWindowSize $hInstallDlg 480 390
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnShowMore" "enabled" "true"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnHideMore" "enabled" "true"
FunctionEnd


Function OnBtnShowConfig
    ;nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_CONFIG}
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "licenseshow" "visible" "false"
FunctionEnd

Function OnBtnDirPre
    
	StrCpy $R8 "安装尚未完成，您确定退出安装么？"
	StrCpy $R7 "0"
	Call ShowMsgBox
		;nsNiuniuSkin::PrePage "wizardTab"
FunctionEnd


Function un.ShowMsgBox
	nsNiuniuSkin::InitSkinSubPage "msgBox.xml" "btnOK" "btnCancel,btnClose"  ; "提示" "${PRODUCT_NAME} 正在运行，请退出后重试!" 0
	Pop $hInstallSubDlg
	nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "lblTitle" "text" "提示"
	nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "lblMsg" "text" "$R8"
	${If} "$R7" == "1"
		nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "hlCancel" "visible" "true"
	${EndIf}
	
	nsNiuniuSkin::ShowSkinSubPage 0 
FunctionEnd

Function un.ExitDUISetup
	nsNiuniuSkin::ExitDUISetup
FunctionEnd


# 添加一个静默卸载的入口 
Section "un.silentInstallSec" SEC02
    #MessageBox MB_OK|MB_ICONINFORMATION "Test silent install. you can add your silent uninstall code here."
SectionEnd

#执行具体的卸载 
Function un.onUninstall
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkReserveData" "selected"
    Pop $0
	StrCpy $sReserveData $0
		
	#此处检测当前是否有程序正在运行，如果正在运行，提示先卸载再安装 
	nsProcess::_FindProcess "${EXE_NAME}"
	Pop $R0
	
	${If} $R0 == 0
		StrCpy $R8 "${PRODUCT_NAME} 正在运行，请退出后重试!"
		StrCpy $R7 "0"
		Call un.ShowMsgBox
		goto InstallAbort
    ${EndIf}
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnClose" "enabled" "false"
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_UNISTPROCESSING}
	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrUnInstProgress" "min" "0"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrUnInstProgress" "max" "100"
	IntOp $UnInstallValue 0 + 1
	
	Call un.DeleteShotcutAndInstallInfo
	
	IntOp $UnInstallValue $UnInstallValue + 8
    
	#删除文件 
	GetFunctionAddress $0 un.RemoveFiles
    BgWorker::CallAndWait
	InstallAbort:
FunctionEnd

#在线程中删除文件，以便显示进度 
Function un.RemoveFiles
	${Locate} "$INSTDIR" "/G=0 /M=*.*" "un.onDeleteFileFound"
	StrCpy $InstallState "1"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnClose" "enabled" "true"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrUnInstProgress" "value" "100"	
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_UNISTFINISH}
FunctionEnd


#卸载程序时删除文件的流程，如果有需要过滤的文件，在此函数中添加  
Function un.onDeleteFileFound
    ; $R9    "path\name"
    ; $R8    "path"
    ; $R7    "name"
    ; $R6    "size"  ($R6 = "" if directory, $R6 = "0" if file with /S=)
    
	
	#是否过滤删除  
			
	Delete "$R9"
	RMDir /r "$R9"
    RMDir "$R9"
	
	IntOp $UnInstallValue $UnInstallValue + 2
	${If} $UnInstallValue > 100
		IntOp $UnInstallValue 100 + 0
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrUnInstProgress" "value" "100"	
	${Else}
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrUnInstProgress" "value" "$UnInstallValue"	
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "un_progress_pos" "text" "$UnInstallValue%"
		
		Sleep 100
	${EndIf}	
	undelete:
	Push "LocateNext"	
FunctionEnd