#!/bin/sh 
#感谢小兔兔
check=1
wget --spider --quiet --timeout=6 www.baidu.com/img/bd_logo1.png
if [ "$?" == "0" ]; then
	PIDS=$(ps | grep "adbyby" | grep -v "grep" | wc -l)
		if [ "$PIDS" = 0 ]; then
			check=$check+1
			logger -t "adbyby" "注意：adbyby意外关闭，将重启adbyby!"
			/etc/init.d/adbyby restart ; sleep 5
		else
			port=$(iptables -t nat -L | grep 8118 | wc -l)
			if [ "$port" = 0 ]; then
				check=$check+1
				logger -t "adbyby" "注意：防火墙转发规则丢失，将重启adbyby！"
				/etc/init.d/adbyby restart ; sleep 5
			fi
			while [[ "$port" -ge 2 ]]
			do
				check=$check+1
				logger -t "adbyby" "注意：发现多条防火墙转发规则，将删除多余规则！"
				iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8118
				port=$(iptables -t nat -L | grep 8118 | wc -l)
			done
			if [ "$PIDS" -ge 6 ]; then
				check=$check+1
				logger -t "adbyby" "注意：发现多于6个adbyby进程，将重启adbyby！"
				ps |grep "/usr/share/adbyby/adbyby" | grep -v 'grep' | awk '{print $1}' |xargs kill -9
				/etc/init.d/adbyby restart ; sleep 5
			fi
		fi
else
	check=$check+1
	logger -t "adbyby" "注意：路由器网络连接异常，将关闭adbyby，请网络恢复后手动重启！"
	/etc/init.d/adbyby stop
fi
if [ "$check" = 1 ]; then
	logger -t "adbyby" "adbyby守护脚本运行完毕，adbyby工作正常"
fi
