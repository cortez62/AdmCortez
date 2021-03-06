#!/bin/bash

auto_add_user () {
#$1 = usuário
#$2 = senha
#$3 = limite
#$4 = data
if [ "$1" = "" ]; then
echo -e "${cor[4]} ${txt[114}"
var_exit="1"
fi
if [ "$2" = "" ]; then
echo -e "${cor[4]} ${txt[114}"
var_exit="1"
fi
if [ "$3" = "" ]; then
echo -e "${cor[4]} ${txt[114}"
var_exit="1"
fi
if [ "$4" = "" ]; then
echo -e "${cor[4]} ${txt[114}"
var_exit="1"
fi
if [ "$var_exit" = "1" ]; then
sleep 0.5s
unset var_exit
 else
if [ "$OPENVPN" = "on" ]; then
open_1 $1 $2 30 $3 s
return
fi
useradd -M -s /bin/false $1 -e $4
(echo $2; echo $2) | passwd $1 2>/dev/null
echo -e "${cor[5]} $1 Criado Com Sucesso!"
echo -e "Usuario: $1"
echo -e "Senha: $2"
echo -e "Loguins: $3"
echo -e "Data: $4"
 if [ -e $dir_user/$1 ]; then
rm $dir_user/$1
 fi
touch $dir_user/$1
echo "senha: $senha" >> $dir_user/$1
echo "limite: $limite" >> $dir_user/$1
echo "data: $data" >> $dir_user/$1
fi
}

function_1 () {
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
echo -e "${cor[4]} ${txt[99]}"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
for user in `awk -F : '$3 > 900 { print $1 }' /etc/passwd | grep -v "nobody" |grep -vi polkitd |grep -vi systemd-[a-z] |grep -vi systemd-[0-9]`; do
echo -e "${cor[5]} ${txt[100]}"
echo -e "\033[1;31m $user"
if [ -e $dir_user/$user ]; then
pass=$(cat $dir_user/$user | grep "senha" | awk '{print $2}')
data=$(cat $dir_user/$user | grep "data" | awk '{print $2}')
limit=$(cat $dir_user/$user | grep "limite" | awk '{print $2}')
 if [ "$pass" = "" ]; then
pass="ultimate"
 fi
 if [ "$data" = "" ]; then
data=$(date '+%C%y-%m-%d' -d "+30 days")
 fi
 if [ "$limit" = "" ]; then
limit="30"
 fi
 if [ ! -e "$HOME/adm-backup" ]; then
echo "$user $pass $limit $data" > /root/adm-backup
echo -e "${cor[4]} $user\n $pass\n $limit\n $data"
 else
echo "$user $pass $limit $data" >> /root/adm-backup
echo -e "${cor[4]} $user\n $pass\n $limit\n $data"
 fi
else
echo -e "${cor[5]} ${txt[101]}"
echo -e "${cor[5]} ${txt[102]}"
read -p " ©$user ${txt[103]} " pass
read -p " ©$user ${txt[104]} " datas2
number_var $datas2
if [ "$var_number" = "" ]; then
 if [ -e $HOME/adm-backup ]; then
rm $HOME/adm-backup
 fi
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
return
 else
datas="$var_number"
fi
data=$(date '+%C%y-%m-%d' -d "+$datas days")
read -p " ©$user ${txt[105]} " limit2
number_var $limit2
if [ "$var_number" = "" ]; then
 if [ -e $HOME/adm-backup ]; then
rm $HOME/adm-backup
 fi
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
return
 else
limit="$var_number"
fi
 if [ ! -e "$HOME/adm-backup" ]; then
echo "$user $pass $limit $data" > /root/adm-backup
echo -e "${cor[4]} $user\n $pass\n $limit\n $data"
 else
echo "$user $pass $limit $data" >> /root/adm-backup
echo -e "${cor[4]} $user\n $pass\n $limit\n $data"
 fi
fi
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
done
echo "admpro" >> $HOME/adm-backup
echo -e "${cor[5]} ${txt[106]}"
echo -e "${cor[5]} ${txt[107]} \033[1;36m$HOME/adm-backup! ${cor[0]}"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
}

function_2 () {
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
echo -e "${cor[4]} ${txt[108]}
 ${txt[109]}"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
read -p " [${txt[110]}]: " arq
 if [ ! -e "$arq" ]; then
cd $HOME
wget -O backup-adm $arq -o /dev/null
  if [ ! -e "$HOME/backup-adm" ]; then
echo -e "${cor[5]} ${txt[111]}"
return
  fi
test=$(cat $HOME/backup-adm | egrep -o "admpro")
  if [ "$test" = "" ]; then
echo -e "${cor[5]} ${txt[112]}"
return
  fi
arq_bkp="$HOME/backup-adm"
    else
test=$(cat $arq | egrep -o "admpro")
  if [ "$test" = "" ]; then
echo -e "${cor[5]} ${txt[112]}"
return
  else
arq_bkp="$arq"
  fi
 fi
echo -e "\033[1;37m ${txt[113]}"
cd /etc/adm-lite
while read backup_adm; do
usuario=$(echo "$backup_adm" | awk '{print $1}')
senha=$(echo "$backup_adm" | awk '{print $2}')
limite=$(echo "$backup_adm" | awk '{print $3}')
data=$(echo "$backup_adm" | awk '{print $4}')
fim=$(echo "$backup_adm" | egrep -o "admpro")
if [ "$fim" != "" ]; then
break
fi
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
auto_add_user "$usuario" "$senha" "$limite" "$data"
done < $arq_bkp
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
cd /etc/adm-lite
}

function_3 () {
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
echo -e "${cor[4]} ${txt[115]}
 ${txt[116]}"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}" 
echo 3 > /proc/sys/vm/drop_caches
sysctl -w vm.drop_caches=3 > /dev/null 2>&1
rm -rf /tmp/*
echo -e "${cor[5]} ${txt[117]}"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
}

function_4 () {
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
if [ "$pid_badvpn" = "" ]; then
echo -e "${cor[4]} ${txt[118]}
 ${txt[119]}
 ${txt[120]}
 ${txt[121]}"
echo -e "${cor[5]} ${txt[122]}"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
cd $HOME
wget https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/PROYECTOS_DESCONTINUADOS/master/ADM-MANAGER-ULTIMATE-BETA/Install/badvpn-udpgw -o /dev/null
mv -f $HOME/badvpn-udpgw /bin/badvpn-udpgw
chmod 777 /bin/badvpn-udpgw
screen -dmS screen /bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10
pid_badvpn=$(ps x | grep badvpn | grep -v grep | awk '{print $1}')
 if [ "$pid_badvpn" != "" ]; then
echo -e "${cor[4]} ${txt[123]}"
 else
echo -e "${cor[4]} ${txt[284]}"
 fi
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
unset pid_badvpn
return
fi
echo -e "${cor[4]} ${txt[124]}"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
kill -9 $(ps x | grep badvpn | grep -v grep | awk '{print $1'}) > /dev/null 2>&1
killall badvpn-udpgw > /dev/null 2>&1
pid_badvpn=$(ps x | grep badvpn | grep -v grep | awk '{print $1}')
if [ "$pid_badvpn" = "" ]; then
echo -e "${cor[4]} ${txt[125]}"
fi
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
unset pid_badvpn
}

function_5 () {
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
echo -e "${cor[4]} ${txt[126]}"
echo -e "${cor[4]} ${txt[127]}"
echo -e "${cor[4]} ${txt[128]}"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
echo -e "${cor[5]} ${txt[129]}"
sleep 1s
if [[ `grep -c "^#ADM" /etc/sysctl.conf` -eq 0 ]]; then
#INSTALA
echo -e "${cor[5]} ${txt[130]}"
echo -e "${cor[5]} ${txt[131]}"
echo -e "${cor[5]} ${txt[132]}"
echo -e "${cor[5]} ${txt[133]}"
echo -e "${cor[5]} ${txt[134]}"
echo -e "${cor[5]} ${txt[135]}"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
read -p " ${txt[136]} [s/n]: " -e -i s resp_osta
echo -e "\033[1;37m"
if [[ "$resp_osta" = 's' ]]; then
unset resp_osta
echo "#ADM" >> /etc/sysctl.conf
echo "net.ipv4.tcp_window_scaling = 1
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 16384 16777216
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_slow_start_after_idle = 0" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf > /dev/null 2>&1
echo -e "${cor[5]} ${txt[137]} TCP"
echo -e "${cor[5]} ${txt[138]}"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
return
 else
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
return
fi
 else
#REMOVE
echo -e "${cor[5]} ${txt[137]} TCP"
echo -e "${cor[5]} ${txt[139]}"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
read -p " ${txt[140]} TCP? [s/n]: " -e -i n res_posta
if [[ "$res_posta" = 's' ]]; then
unset res_posta
grep -v "^#ADM
net.ipv4.tcp_window_scaling = 1
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 16384 16777216
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_slow_start_after_idle = 0" /etc/sysctl.conf > /tmp/syscl && mv -f /tmp/syscl /etc/sysctl.conf
sysctl -p /etc/sysctl.conf > /dev/null 2>&1
echo -e "${cor[5]} ${txt[141]} TCP"
echo -e "${cor[5]} ${txt[142]}"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
return
 else
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
return
 fi
fi
}

function_6 () {
source fai2ban
}


function_7 () {
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
echo -e "${cor[5]} ${txt[157]}"
echo -e "${cor[5]} ${txt[158]}"
echo -e "${cor[5]} ${txt[159]}"
echo -e "${cor[5]} ${txt[160]}"
echo -e "${cor[5]} ${txt[161]}"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
sleep 2s
if [ -e /etc/squid/squid.conf ]; then
squid_var="/etc/squid/squid.conf"
squid_var2="1"
else
 if [ -e /etc/squid3/squid.conf ]; then
squid_var="/etc/squid3/squid.conf"
squid_var2="2"
else
echo -e "${cor[5]} ${txt[162]}"
return
 fi
fi
teste_cache="#CACHE DO SQUID"
if [[ `grep -c "^$teste_cache" $squid_var` -eq 0 ]]; then
echo -e "${cor[5]} ${txt[163]}"
echo -e "${cor[5]} ${txt[164]}"
 else
 if [[ -e "$squid_var".bakk ]]; then
echo -e "${cor[5]} ${txt[167]}"
echo -e "${cor[5]} ${txt[168]}"
mv -f "$squid_var".bakk $squid_var
echo -e "${cor[5]} ${txt[165]}"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
service squid restart > /dev/null 2>&1
service squid3 restart > /dev/null 2>&1
 fi
return
fi
echo -e "${cor[5]} ${txt[166]}"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
echo "#CACHE DO SQUID
cache_mem 200 MB
maximum_object_size_in_memory 32 KB
maximum_object_size 1024 MB
minimum_object_size 0 KB
cache_swap_low 90
cache_swap_high 95" > $_tmp
if [ "$squid_var2" = "1" ]; then
echo "cache_dir ufs /var/spool/squid 100 16 256
access_log /var/log/squid/access.log squid" >> $_tmp
 else
 if [ "$squid_var2" = "2" ]; then
echo "cache_dir ufs /var/spool/squid3 100 16 256
access_log /var/log/squid3/access.log squid
" >> $_tmp
 else
return
 fi
fi
while read s_squid; do
if [ "$s_squid" != "cache deny all" ]; then
echo "$s_squid" >> $_tmp
fi
done < $squid_var
cp $squid_var $squid_var.bakk
mv -f $_tmp $squid_var
echo -e "${cor[5]} ${txt[165]}"
echo -e "${cor[5]} ${txt[168]}"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
service squid restart > /dev/null 2>&1
service squid3 restart > /dev/null 2>&1
}

function_8 () {
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
echo -e "${cor[5]} ${txt[170]}"
echo -e "${cor[5]} ${txt[171]}"
echo -e "${cor[5]} ${txt[172]}"
echo -e "${cor[5]} ${txt[173]} \033[1;31m$HOME"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
meu_ip
echo -e "${cor[2]} |1|•${cor[3]} ${txt[169]}"
echo -e "${cor[2]} |2|•${cor[3]} ${txt[174]}"
echo -e "${cor[2]} |3|•${cor[3]} ${txt[175]}"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
read -p " |1-3|: " arquivo_online_adm
number_var $arquivo_online_adm
if [ "$var_number" = "" ]; then
return
 else
online_adm="$var_number"
fi
if [ "$online_adm" -gt 3 ]; then
echo -e "${cor[5]} ${txt[175]}"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
return
fi
if [ "$online_adm" = 3 ]; then
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
for my_arqs in `ls /var/www/html`; do
if [ "$my_arqs" != "index.html" ]; then
 if [ ! -d "$my_arqs" ]; then
echo -e " \033[1;36mhttp://$IP:81/$my_arqs\033[0m"
 fi
fi
done
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
return
fi
if [ "$online_adm" = 2 ]; then
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
unset _cont
_cont="1"
for my_arqs in `ls /var/www/html`; do
if [ "$my_arqs" != "index.html" ]; then
 if [ ! -d "$my_arqs" ]; then
select_arc[$_cont]="$my_arqs"
echo -e "${cor[2]} |$_cont|• ${cor[3]}$my_arqs - \033[1;36mhttp://$IP:81/$my_arqs\033[0m"
_cont=$(($_cont + 1))
 fi
fi
done
_cont=$(($_cont - 1))
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
echo -e "${cor[5]} ${txt[177]}"
read -p " | 1 - $_cont |: " slct
number_var $slct
if [ "$var_number" = "" ]; then
return
 else
slct="$var_number"
fi
unset _cont
arquivo_move="${select_arc[$slct]}"
 if [ "$arquivo_move" = "" ]; then
echo -e "${cor[5]} ${txt[178]}"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
return
 fi
rm -rf /var/www/html/$arquivo_move > /dev/null 2>&1
rm -rf /var/www/$arquivo_move > /dev/null 2>&1
echo -e "${cor[5]} ${txt[179]}"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
return
fi
unset _cont
_cont="1"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
echo -e "${cor[5]} ${txt[181]}"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
for my_arqs in `ls $HOME`; do
if [ ! -d "$my_arqs" ]; then
select_arc[$_cont]="$my_arqs"
echo -e "${cor[2]} |$_cont|• ${cor[3]}$my_arqs"
_cont=$(($_cont + 1))
fi
done
_cont=$(($_cont - 1))
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
echo -e "${cor[5]} ${txt[177]}"
read -p " | 1 - $_cont |: " slct
number_var $slct
if [ "$var_number" = "" ]; then
return
 else
slct="$var_number"
fi
unset _cont
arquivo_move="${select_arc[$slct]}"
if [ "$arquivo_move" = "" ]; then
echo -e "${cor[5]} ${txt[178]}"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
return
fi
if [ ! -d /var ]; then
mkdir /var
fi
if [ ! -d /var/www ]; then
mkdir /var/www
fi
if [ ! -d /var/www/html ]; then
mkdir /var/www/html
fi
if [ ! -e /var/www/html/index.html ]; then
touch /var/www/html/index.html
fi
if [ ! -e /var/www/index.html ]; then
touch /var/www/index.html
fi
chmod -R 755 /var/www
cp $HOME/$arquivo_move /var/www/$arquivo_move
cp $HOME/$arquivo_move /var/www/html/$arquivo_move
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
echo -e "${cor[5]} ${txt[180]}"
echo -e "\033[1;36m http://$IP:81/$arquivo_move\033[0m"
echo -e "${cor[5]} ${txt[179]}"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
}

function_9 () {
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
echo -e "${cor[4]} ${txt[184]}"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
ping=$(ping -c1 google.com |awk '{print $8 $9}' |grep -v loss |cut -d = -f2 |sed ':a;N;s/\n//g;ta')
starts_test=$(python ./speedtest.py)
down_load=$(echo "$starts_test" | grep "Download" | awk '{print $2,$3}')
up_load=$(echo "$starts_test" | grep "Upload" | awk '{print $2,$3}')
echo -e "${cor[5]} ${txt[185]}: $ping"
echo -e "${cor[5]} ${txt[186]}: $up_load"
echo -e "${cor[5]} ${txt[187]}: $down_load"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
}

function_10 () {
null="\033[1;31m"
echo -e "${cor[1]} ════════════════════════════════════════════════════════════════════════════ ${cor[0]}"
if [ ! /proc/cpuinfo ]; then
echo -e "${cor[4]} ${txt[188]}"
echo -e "${cor[1]} ════════════════════════════════════════════════════════════════════════════ ${cor[0]}"
return
fi
if [ ! /etc/issue.net ]; then
echo -e "${cor[4]} ${txt[188]}"
echo -e "${cor[1]} ════════════════════════════════════════════════════════════════════════════ ${cor[0]}"
return
fi
if [ ! /proc/meminfo ]; then
echo -e "${cor[4]} ${txt[188]}"
echo -e "${cor[1]} ════════════════════════════════════════════════════════════════════════════ ${cor[0]}"
return
fi
totalram=$(free | grep Mem | awk '{print $2}')
usedram=$(free | grep Mem | awk '{print $3}')
freeram=$(free | grep Mem | awk '{print $4}')
swapram=$(cat /proc/meminfo | grep SwapTotal | awk '{print $2}')
system=$(cat /etc/issue.net)
clock=$(lscpu | grep "CPU MHz" | awk '{print $3}')
based=$(cat /etc/*release | grep ID_LIKE | awk -F "=" '{print $2}')
processor=$(cat /proc/cpuinfo | grep "model name" | uniq | awk -F ":" '{print $2}')
cpus=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ "$system" ]; then
echo -e "${cor[5]} ${txt[189]}: ${null}$system"
else
echo -e "${cor[5]} ${txt[189]}: ${null}???"
fi
if [ "$based" ]; then
echo -e "${cor[5]} ${txt[190]}: ${null}$based"
else
echo -e "${cor[5]} ${txt[190]}: ${null}???"
fi
if [ "$processor" ]; then
echo -e "${cor[5]} ${txt[191]}: ${null}$processor x$cpus"
else
echo -e "${cor[5]} ${txt[191]}: ${null}???"
fi
if [ "$clock" ]; then
echo -e "${cor[5]} ${txt[192]}: ${null}$clock MHz"
else
echo -e "${cor[5]} ${txt[192]}: ${null}???"
fi
echo -e "${cor[5]} ${txt[193]}: ${null}$(ps aux  | awk 'BEGIN { sum = 0 }  { sum += sprintf("%f",$3) }; END { printf " " "%.2f" "%%", sum}')"
echo -e "${cor[5]} ${txt[194]}: ${null}$(($totalram / 1024))"
echo -e "${cor[5]} ${txt[195]}: ${null}$(($usedram / 1024))"
echo -e "${cor[5]} ${txt[196]}: ${null}$(($freeram / 1024))"
echo -e "${cor[5]} ${txt[197]}: ${null}$(($swapram / 1024))MB"
echo -e "${cor[5]} ${txt[198]}: ${null}$(uptime)"
echo -e "${cor[5]} ${txt[199]}: ${null}$(hostname)"
echo -e "${cor[5]} ${txt[200]}: ${null}$(ip addr | grep inet | grep -v inet6 | grep -v "host lo" | awk '{print $2}' | awk -F "/" '{print $1}')"
echo -e "${cor[5]} ${txt[201]}: ${null}$(uname -r)"
echo -e "${cor[5]} ${txt[202]}: ${null}$(uname -m)"
echo -e "${cor[1]} ════════════════════════════════════════════════════════════════════════════ ${cor[0]}"
return
}

function_11 () {
payload="/etc/payloads"
if [ ! -f "$payload" ]; then
echo -e "${cor[5]} $payload ${txt[213]}"
echo -e "${cor[5]} ${txt[214]}"
return
fi
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
echo -e "${cor[2]} |1|•${cor[3]} ${txt[215]}"
echo -e "${cor[2]} |2|•${cor[3]} ${txt[216]}"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
read -p " | 1 - 2 |: " var_pay
number_var $var_pay
if [ "$var_number" = "" ]; then
echo -e "\033[1;31m ${txt[217]}"
return
 else
var_payload="$var_number"
fi
if [ "$var_payload" -gt "2" ]; then
echo -e "\033[1;31m ${txt[217]}"
return
fi
if [ "$var_payload" = "1" ]; then
echo -e "${cor[4]} ${txt[215]}"
echo -e "${cor[5]} ${txt[218]} $payload:"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
read -p " ${txt[219]} ${txt[220]}: " hos
if [[ $hos != \.* ]]; then
echo -e "${cor[5]} ${txt[220]}"
return
fi
host="$hos/"
if [[ -z $host ]]; then
echo -e "${cor[5]} ${txt[221]}"
return
fi
if [[ `grep -c "^$host" $payload` -eq 1 ]]; then
echo -e "${cor[5]} ${txt[222]}"
return
fi
echo "$host" >> $payload && grep -v "^$" $payload > /tmp/a && mv /tmp/a $payload
echo -e "${cor[5]} ${txt[223]}"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
 if [ ! -f "/etc/init.d/squid" ]; then
service squid3 reload
service squid3 restart
 else
/etc/init.d/squid reload
service squid restart
 fi	
return
fi

if [ "$var_payload" = "2" ]; then
echo -e "${cor[4]} ${txt[216]}"
echo -e "${cor[5]} ${txt[218]} $payload:"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
read -p " ${txt[224]} ${txt[220]}: " hos
if [[ $hos != \.* ]]; then
echo -e "${cor[5]} ${txt[220]}"
return
fi
host="$hos/"
if [[ -z $host ]]; then
echo -e "${cor[5]} ${txt[221]}"
return
fi
if [[ `grep -c "^$host" $payload` -ne 1 ]]; then
echo -e "${cor[5]} ${txt[225]}"
return
fi
grep -v "^$host" $payload > /tmp/a && mv /tmp/a $payload
echo -e "${cor[5]} ${txt[223]}"
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
echo -e "${cor[1]} ══════════════════════════════════════════════════════ ${cor[0]}"
 if [ ! -f "/etc/init.d/squid" ]; then
service squid3 reload
service squid3 restart
 else
/etc/init.d/squid reload
service squid restart
 fi	
return
fi
}

criar_pay () {
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
echo -e "${cor[5]} ${txt[258]}"
echo -e "${cor[5]} ${txt[259]}"
echo -e "${cor[5]} ${txt[260]}"
echo -e "${cor[5]} ${txt[261]}"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[3]}"
read -p " => " valor1
if [ "$valor1" = "" ]; then
echo -e "${cor[5]} ${txt[262]}"
return
fi
meu_ip
valor2="$IP"
if [ "$valor2" = "" ]; then
valor2="127.0.0.1"
fi
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
echo -e "${cor[5]} ${txt[264]} ${cor[3]}"
echo -e " 1-GET"
echo -e " 2-CONNECT"
echo -e " 3-PUT"
echo -e " 4-OPTIONS"
echo -e " 5-DELETE"
echo -e " 6-HEAD"
echo -e " 7-TRACE"
echo -e " 8-PROPATCH"
echo -e " 9-PATCH"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[3]}"
read -p " => " valor3
case $valor3 in
1)
req="GET"
;;
2)
req="CONNECT"
;;
3)
req="PUT"
;;
4)
req="OPTIONS"
;;
5)
req="DELETE"
;;
6)
req="HEAD"
;;
7)
req="TRACE"
;;
8)
req="PROPATCH"
;;
9)
req="PATCH"
;;
*)
req="GET"
;;
esac
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
echo -e "${cor[5]} ${txt[265]}"
echo -e "${cor[5]} ${txt[266]} ${cor[3]}"
echo -e " 1-realData"
echo -e " 2-netData"
echo -e " 3-raw"
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
read -p " => " valor4
case $valor4 in
1)
in="realData"
;;
2)
in="netData"
;;
3)
in="raw"
;;
*)
in="netData"
;;
esac
echo -e "${cor[1]} ══════════════════════════════════= ${cor[0]}"
name=$(echo $valor1 | awk -F "/" '{print $2'})
if [ "$name" = "" ]; then
name=$(echo $valor1 | awk -F "/" '{print $1'})
fi
esquelet="/etc/adm-lite/payloads"
sed -s "s;realData;abc;g" $esquelet > $HOME/$name.txt
sed -i "s;netData;abc;g" $HOME/$name.txt
sed -i "s;raw;abc;g" $HOME/$name.txt
sed -i "s;abc;$in;g" $HOME/$name.txt
sed -i "s;get;$req;g" $HOME/$name.txt
sed -i "s;mhost;$valor1;g" $HOME/$name.txt
sed -i "s;mip;$valor2;g" $HOME/$name.txt
if [ "$(cat $HOME/$name.txt | egrep -o "$valor1")" = "" ]; then
echo -e ""
echo -e "${cor[3]} ${txt[267]} \033[1;36m${txt[268]}"
rm $HOME/$name.txt
return
fi
echo -e "${cor[3]} ${txt[269]}"
echo -e "${cor[3]} ${txt[270]} \033[1;31m$HOME/$name.txt"
return
}

paybrute () {
chmod +x ./paysnd.sh
./paysnd.sh
}

if [ "$1" = "1" ]; then
function_1
fi
if [ "$1" = "2" ]; then
function_2
fi
if [ "$1" = "3" ]; then
function_3
fi
if [ "$1" = "4" ]; then
function_4
fi
if [ "$1" = "5" ]; then
function_5
fi
if [ "$1" = "6" ]; then
function_6
fi
if [ "$1" = "7" ]; then
function_7
fi
if [ "$1" = "8" ]; then
function_8
fi
if [ "$1" = "9" ]; then
function_9
fi
if [ "$1" = "10" ]; then
function_10
fi
if [ "$1" = "11" ]; then
function_11
fi
if [ "$1" = "12" ]; then
criar_pay
fi
if [ "$1" = "13" ]; then
paybrute
fi

####_Eliminar_Tmps_####
if [ -e $_tmp ]; then
rm $_tmp
fi
if [ -e $_tmp2 ]; then
rm $_tmp2
fi
if [ -e $_tmp3 ]; then
rm $_tmp3
fi
if [ -e $_tmp4 ]; then
rm $_tmp4
fi
