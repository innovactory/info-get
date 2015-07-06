function start_header()
{
    Write-Output "===================="
    Write-Output "OS情報"
    $date = Get-Date
    Write-Output "開始時刻:$date"
    Write-Output "===================="
}

function header($title)
{
    Write-Output ""
    Write-Output "--------------------"
    Write-Output $title
    Write-Output "--------------------"
}

$log_base = "server-info"
$log_time = Get-Date -Format "yyyyMMdd-HHmmss"
$log_file = "${log_base}_${log_time}.log"

start_header > $log_file

# 0000 システムINFO
header "システムINFO"  >> $log_file
systeminfo  >> $log_file

# 0001 ホスト名
header "ホスト名"  >> $log_file
hostname  >> $log_file

# 0002 OSバージョン
header "OSバージョン"  >> $log_file
[Environment]::OSVersion  >> $log_file

# 0003 ディスク構成
header "ディスク構成"  >> $log_file
Get-WmiObject Win32_DiskDrive  >> $log_file
echo list volume | diskpart

# 0004 ドメイン参加情報
header "ドメイン参加情報"  >> $log_file
Get-WmiObject Win32_ComputerSystem  >> $log_file


# 0005 ネットワーク設定
header "ネットワーク設定"  >> $log_file
#Get-WmiObject Win32NetworkAdapterConfiguration
ipconfig /all  >> $log_file
route print  >> $log_file
netstat -an  >> $log_file

# 0006 役割情報、機能情報
header "役割情報、機能情報"  >> $log_file
Import-Module ServerManager  >> $log_file
Get-WindowsFeature  >> $log_file

# 0007 適用済みセキュリティパッチ
header "適用済みセキュリティパッチ"  >> $log_file
Get-WmiObject Win32_QuickFixEngineering  >> $log_file

# 0008 インストール済みアプリケーション
header "インストール済みアプリケーション"  >> $log_file
gwmi -Class Win32_product  >> $log_file

# 0009 FireWall◆
header "FireWall"  >> $log_file
netsh advfirewall show allprofiles  >> $log_file
netsh advfirewall firewall show rule name=all  >> $log_file


# 0010 User/Group
header "User/Group"  >> $log_file
net user  >> $log_file
net localgroup  >> $log_file
#Get-ADUser -Filter * #AD

# 0011 Windows Update Settings
header "Windows Update Settings(0=Disabled,1=OnlyNotificate,3=DownloadOnly,4=FullAuto)"  >> $log_file
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions  >> $log_file

# Get-WmiObject -Class Win32_QuickFixEngineering ⇒文字がつぶれる。

# 0012 NTP Settings
header "NTP Settings"  >> $log_file
# NTP
net start w32time >> $log_file
w32tm /query /status >> $log_file
w32tm /query /configuration  >> $log_file
w32tm /query /status /verbose  >> $log_file
net stop w32time >> $log_file

# 0013 Share Files
header "Share Files"  >> $log_file
net share  >> $log_file
# gwmi  -Class Win32_Share

# 0014 Servise
header "Service"  >> $log_file
get-service  >> $log_file
get-service | Format-List *  >> $log_file
wmic Service  >> $log_file

# 0015 Task Schedule
header "Task Schedule"  >> $log_file
schtasks /query  >> $log_file
schtasks /query /v  >> $log_file

# 0016 Windows Backup Setting
header "Windows Backup Setting"  >> $log_file
wbadmin enable backup  >> $log_file
wbadmin get versions  >> $log_file
wbadmin get disks  >> $log_file

# 0017 Remote Desktop Enable
header "Remote Desktop Enable(0x0=Enable,Portdefult=0xd3d(3389))"  >> $log_file
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections  >> $log_file
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber  >> $log_file


# 0018 All Devices
header "All Devices"  >> $log_file
powercfg /devicequery all_devices  >> $log_file

# 0019 Group Polcy/Local Security Policy
header "Group Polcy/Local Security Policy"  >> $log_file
gpresult /z  >> $log_file
gpresult /h .\gporesult_$log_time.html
secedit /export /areas SECURITYPOLICY /cfg .\secedit_$log_time.txt  >> $log_file
type .\secedit_$log_time.txt >> $log_file

# 0020 Get env
header "Get env"  >> $log_file
Get-ChildItem env: >> $log_file
Get-ChildItem env: | Format-List *  >> $log_file

# 0021 ODBC
header "ODBC"  >> $log_file
type C:\windows\odbc.ini  >> $log_file

# 0022 hosts
header "hosts"  >> $log_file
type c:\Windows\System32\drivers\etc\hosts  >> $log_file

# 0023 Services
header "Services"  >> $log_file
type c:\Windows\System32\drivers\etc\services  >> $log_file

# 0024 Proxy
header "Proxy"  >> $log_file
netsh winhttp show proxy  >> $log_file


