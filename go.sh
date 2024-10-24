#!/bin/bash

# 检测系统架构
ARCH=$(uname -m)
case "$ARCH" in
    aarch64|arm64)
        CFNAT_BINARY="./cfnat-linux-arm64"
        ;;
    *)
        CFNAT_BINARY="./cfnat-linux-amd64"
        ;;
esac

# 记录启动信息
{
echo "系统架构: $ARCH"
echo "使用二进制文件: $CFNAT_BINARY"
echo "使用以下配置启动 cfnat:"
echo "IP类型(ips): $ips"
echo "TLS: $tls"
echo "随机IP(random): $random"
echo "数据中心(colo): $colo"
echo "有效延迟(delay): $delay"
echo "转发端口(port): $port"
echo "有效IP数(ipnum): $ipnum"
echo "负载IP数(num): $num"
echo "最大并发请求数(task): $task"
echo "检查域名(domain): $domain"
} >> cfnat.log

while true
do
    # 记录每次启动时间
    echo "$(date '+%Y-%m-%d %H:%M:%S') - cfnat 启动 ..." >> cfnat.log
    
    # 运行主程序 - 使用检测到的正确二进制文件
    $CFNAT_BINARY \
        -colo="${colo^^}" \
        -port="$port" \
        -delay="$delay" \
        -ips="$ips" \
        -addr="0.0.0.0:1234" \
        -ipnum="$ipnum" \
        -num="$num" \
        -random="$random" \
        -task="$task" \
        -tls="$tls" \
        -domain="$domain"

    # 检查执行是否成功
    if [ $? -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - cfnat 崩溃，5 秒后重启..." >> cfnat.log
    fi

    # 等待 5 秒后重启
    sleep 5
done