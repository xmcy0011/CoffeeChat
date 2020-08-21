Function AdjustInstallPath
	#此处判断最后一段，如果已经是与我要追加的目录名一样，就不再追加了，如果不一样，则还需要追加 同时记录好写入注册表的路径  	
	nsNiuniuSkin::StringHelper "$0" "\" "" "trimright"
	pop $0
	nsNiuniuSkin::StringHelper "$0" "\" "" "getrightbychar"
	pop $1	
		
	${If} "$1" == "${INSTALL_APPEND_PATH}"
		StrCpy $INSTDIR "$0"
	${Else}
		StrCpy $INSTDIR "$0\${INSTALL_APPEND_PATH}"
	${EndIf}

FunctionEnd


#判断选定的安装路径是否合法，主要检测硬盘是否存在[只能是HDD]，路径是否包含非法字符 结果保存在$R5中 
Function IsSetupPathIlleagal

${GetRoot} "$INSTDIR" $R3   ;获取安装根目录  

StrCpy $R0 "$R3\"  
StrCpy $R1 "invalid"  
StrCpy $0 ""  
${GetDrives} "HDD" "HDDDetection"            ;获取将要安装的根目录磁盘类型
${If} $R1 == "HDD"              ;是硬盘       
	 StrCpy $R5 "1"	 
	 ${DriveSpace} "$R3\" "/D=F /S=M" $R0           #获取指定盘符的剩余可用空间，/D=F剩余空间， /S=M单位兆字节  
	 ${If} $R0 < 100                                #400即程序安装后需要占用的实际空间，单位：MB  
	    StrCpy $R5 "-1"		#表示空间不足 
     ${endif}
${Else}  
     #0表示不合法 
	 StrCpy $R5 "0"
${endif}

FunctionEnd

Function HDDDetection
${If} "$R0" == "$9"
StrCpy $R1 "HDD"
StrCpy $0 "StopGetDrives"
${Endif}
Push $0
FunctionEnd

#获取默认的安装路径 
Function GenerateSetupAddress
	#读取注册表安装路径 
	SetRegView 32	
	ReadRegStr $0 HKLM "Software\${PRODUCT_PATHNAME}" "InstPath"
	${If} "$0" != ""		#路径不存在，则重新选择路径  	
		#路径读取到了，直接使用 
		#再判断一下这个路径是否有效 
		nsNiuniuSkin::StringHelper "$0" "\\" "\" "replace"
		Pop $0
		StrCpy $INSTDIR "$0"
	${EndIf}
	
	#如果从注册表读的地址非法，则还需要写上默认地址      
	Call IsSetupPathIlleagal
	${If} $R5 == "0"
		StrCpy $INSTDIR "$PROGRAMFILES32\${INSTALL_APPEND_PATH}"		
	${EndIf}	
	
FunctionEnd


#====================获取默认安装的要根目录 结果存到$R5中 
Function GetDefaultSetupRootPath
#先默认到D盘 
${GetRoot} "D:\" $R3   ;获取安装根目录  
StrCpy $R0 "$R3\"  
StrCpy $R1 "invalid"  
${GetDrives} "HDD" "HDDDetection"            ;获取将要安装的根目录磁盘类型
${If} $R1 == "HDD"              ;是硬盘  
     #检查空间是否够用
	 StrCpy $R5 "D:\" 2 0
	 ${DriveSpace} "$R3\" "/D=F /S=M" $R0           #获取指定盘符的剩余可用空间，/D=F剩余空间， /S=M单位兆字节  
	 ${If} $R0 < 300                                #400即程序安装后需要占用的实际空间，单位：MB  
	    StrCpy $R5 "C:"
     ${endif}
${Else}  
     #此处需要设置C盘为默认路径了 
	 StrCpy $R5 "C:"
${endif}
FunctionEnd


# 生成卸载入口 
Function CreateUninstall
	#写入注册信息 
	SetRegView 32
	WriteRegStr HKLM "Software\${PRODUCT_PATHNAME}" "InstPath" "$INSTDIR"
	
	WriteUninstaller "$INSTDIR\uninst.exe"
	
	# 添加卸载信息到控制面板
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_PATHNAME}" "DisplayName" "${PRODUCT_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_PATHNAME}" "UninstallString" "$INSTDIR\uninst.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_PATHNAME}" "DisplayIcon" "$INSTDIR\${EXE_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_PATHNAME}" "Publisher" "${PRODUCT_PUBLISHER}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_PATHNAME}" "DisplayVersion" "${PRODUCT_VERSION}"
FunctionEnd


# ========================= 安装步骤 ===============================
Function CreateAppShortcut
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\卸载${PRODUCT_NAME}.lnk" "$INSTDIR\uninst.exe"
  SetShellVarContext current
FunctionEnd


Function ExtractFunc
	#安装文件的7Z压缩包
	SetOutPath $INSTDIR
	#根据宏来区分是否走非NSIS7Z的进度条  
!ifdef INSTALL_WITH_NO_NSIS7Z
    !include "..\app.nsh"
!else
    File "${INSTALL_7Z_PATH}"
    GetFunctionAddress $R9 ExtractCallback
    nsis7zU::ExtractWithCallback "$INSTDIR\${INSTALL_7Z_NAME}" $R9
	Delete "$INSTDIR\${INSTALL_7Z_NAME}"
!endif
	
	Sleep 100
FunctionEnd

Function un.DeleteShotcutAndInstallInfo
	SetRegView 32
	DeleteRegKey HKLM "Software\${PRODUCT_PATHNAME}"	
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_PATHNAME}"
	
	; 删除快捷方式
	SetShellVarContext all
	Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
	Delete "$SMPROGRAMS\${PRODUCT_NAME}\卸载${PRODUCT_NAME}.lnk"
	RMDir "$SMPROGRAMS\${PRODUCT_NAME}\"	
	Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
	
	#删除开机启动  
    Delete "$SMSTARTUP\${PRODUCT_NAME}.lnk"
	SetShellVarContext current
FunctionEnd
