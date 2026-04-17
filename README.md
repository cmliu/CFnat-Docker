# CFnat-Docker

首先声明，这款软件并非我原创开发，而是目前了解到由 **股神** 在 [CF中转IP 频道](https://t.me/CF_NAT/38840) 发布的一款实时筛选 Cloudflare 数据中心的软件。我所编写的脚本是在这位开发者的原始版本基础上进行的**二次开发**。

由于**该软件尚未开源**，接下来我将根据作者的简介，结合我的理解进行说明。若有不当之处，欢迎指正。

CFnat 是一款自动查找并优化 Cloudflare IP 转发的工具，旨在**解决泛播 IP 路由不稳定的问题**。如果你曾找到过速度不错的 Cloudflare IP，CFnat 能帮助你快速筛选出最佳 IP 并实现端口转发，从而提升网络使用体验。因此，这款工具对于**移动、广电网络用户来说尤为明显**！

CFnat 使用场景也**必须是在国内机子长期上运行！必须是在国内机子长期上运行！必须是在国内机子长期上运行！！！**

- **视频教程：[CFnat Docker篇 多开数据中心！最强官方优选！Cloudflare优选新思路，专治泛播IP动态路由，提升网络体验！](https://youtu.be/_GVqBaSzVwo)**
- **相关项目：[CFnat-Windows-GUI](https://github.com/cmliu/CFnat-Windows-GUI)**
- **Telegram交流群：[@CMLiussss](https://t.me/CMLiussss)**

## 免责声明
CFnat 相关项目仅供教育、研究和安全测试目的而设计和开发。本项目旨在为安全研究人员、学术界人士及技术爱好者提供一个探索和实践网络通信技术的工具。

在下载和使用本项目代码时，使用者必须严格遵守其所适用的法律和规定。使用者有责任确保其行为符合所在地区的法律框架、规章制度及其他相关规定。

### 使用条款

- **教育与研究用途**：本软件仅可用于网络技术和编程领域的学习、研究和安全测试。
- **禁止非法使用**：严禁将 **CFnat-Docker** 用于任何非法活动或违反使用者所在地区法律法规的行为。
- **使用时限**：基于学习和研究目的，建议用户在完成研究或学习后，或在安装后的**24小时内，删除本软件及所有相关文件。**
- **免责声明**：**CFnat-Docker** 的创建者和贡献者不对因使用或滥用本软件而导致的任何损害或法律问题负责。
- **用户责任**：**用户对使用本项目的方式以及由此产生的任何后果完全负责。**
- **无技术支持**：本项目的创建者不提供任何技术支持或使用协助。
- **知情同意**：使用 **CFnat-Docker** 即表示您已阅读并理解本免责声明，并同意受其条款的约束。

**请记住**：本项目的主要目的是促进学习、研究和安全测试。作者不支持或认可任何其他用途。使用者应当在合法和负责任的前提下使用本工具。

## 使用方法
### 一键命令

- 官方仓库拉取

```shell
docker run -d --name mycfnat --restart always -p 1234:1234 cmliu/cfnat:latest
```

- 镜像仓库拉取

```shell
docker run -d --name mycfnat --restart always -p 1234:1234 docker.fxxk.dedyn.io/cmliu/cfnat:latest
```

### 创建 `docker-compose.yml`
```yml
version: '3'

services:
  cfnat:
    container_name: mycfnat
    image: cmliu/cfnat:latest
    environment:
      - colo=HKG,SJC,LAX  # 筛选数据中心例如 HKG,SJC,LAX.电信/联通 推荐 SJC,LAX.移动/广电 推荐 HKG"
      - delay=300  # 有效延迟（毫秒），超过此延迟将断开连接
      - ips=4  # 指定生成IPv4还是IPv6地址
      - port=443  # 转发的目标端口
      - tls=true  # 是否为 TLS 端口
      - random=true  # 是否随机生成IP，如果为false，则从CIDR中拆分出所有IP
      - ipnum=10  # 提取的有效IP数量
      - num=10  # 目标负载 IP 数量
      - task=100  # 并发请求最大协程数
      - code=200  # HTTP/HTTPS 响应状态码
      - domain=cloudflaremirrors.com/debian # 响应状态码检查的域名地址
    ports:
      - "1234:1234"  # 将主机的 1234 端口映射到容器的 1234 端口
    restart: always
```

## **使用案例** 
- 数据中心(colo): HKG
- 有效延迟(delay): 160
- IP类型(ips): 6
```shell
docker run -d -e colo="HKG" -e delay=160 -e ips=6 --restart always -p 1234:1234 cmliu/cfnat:latest
```

----

- 数据中心(colo): HKG
- 有效延迟(delay): 160
- IP类型(ips): 4
- 转发端口(port): 80
- tls: false
- **本地映射端口: 8080**
```shell
docker run -d -e colo="HKG" -e delay=160 -e ips=4 -e port=80 -e tls=false --restart always -p 8080:1234 cmliu/cfnat:latest
```

----

- 数据中心(colo): SJC,LAX
- 有效延迟(delay): 300
- IP类型(ips): 4
```shell
docker run -d -e colo="SJC,LAX" -e delay=300 -e ips=4 --restart always -p 1234:1234 cmliu/cfnat:latest
```

----

- 数据中心(colo): LAX
- 有效延迟(delay): 300
- IP类型(ips): 4
- 转发端口(port): 80
- tls: false
- 随机IP(random): true
- 有效IP数(ipnum): 10
- 负载IP数(num): 10
- 最大并发请求数(task): 100
- 响应状态码(code): 200
- 检查域名(domain): "cloudflaremirrors.com/debian"
```shell
docker run -d \
    -e colo="LAX" \
    -e delay=300 \
    -e ips=4 \
    -e port=80 \
    -e tls=false \
    -e random=true \
    -e ipnum=10 \
    -e num=10 \
    -e task=100 \
    -e code=200 \
    -e domain="cloudflaremirrors.com/debian" \
    --restart always \
    -p 1234:1234 \
    cmliu/cfnat:latest
```

----

- 使用`docker-compose.yml`同时启动**多个cfnat容器**
```yml


version: '3'

services:
      cfnat1:
            container_name: cfnathkg443
            image: cmliu/cfnat:latest
            environment:
                  - colo=HKG  # 筛选数据中心例如 HKG,SJC,LAX.电信/联通 推荐 SJC,LAX.移动/广电 推荐 HKG
                  - delay=160  # 有效延迟（毫秒），超过此延迟将断开连接
                  #- ips=4  # 指定生成IPv4还是IPv6地址
                  - port=443  # 转发的目标端口
                  #- tls=true  # 是否为 TLS 端口
                  #- random=true  # 是否随机生成IP，如果为false，则从CIDR中拆分出所有IP
                  #- ipnum=10  # 提取的有效IP数量
                  #- num=10  # 目标负载 IP 数量
                  - task=64  # 并发请求最大协程数
                  #- code=200  # HTTP/HTTPS 响应状态码
                  #- domain=cloudflaremirrors.com/debian # 响应状态码检查的域名地址
            ports:
                  - "443:1234"  # 将主机的 443 端口映射到容器的 1234 端口
            restart: always

      cfnat2:
            container_name: cfnathkg80
            image: cmliu/cfnat:latest
            environment:
                  - colo=HKG  # 筛选数据中心例如 HKG,SJC,LAX.电信/联通 推荐 SJC,LAX.移动/广电 推荐 HKG
                  - delay=160  # 有效延迟（毫秒），超过此延迟将断开连接
                  #- ips=4  # 指定生成IPv4还是IPv6地址
                  - port=80  # 转发的目标端口
                  - tls=false  # 是否为 TLS 端口
                  #- random=true  # 是否随机生成IP，如果为false，则从CIDR中拆分出所有IP
                  #- ipnum=10  # 提取的有效IP数量
                  #- num=10  # 目标负载 IP 数量
                  - task=64  # 并发请求最大协程数
                  #- code=200  # HTTP/HTTPS 响应状态码
                  #- domain=cloudflaremirrors.com/debian # 响应状态码检查的域名地址
            ports:
                  - "80:1234"  # 将主机的 80 端口映射到容器的 1234 端口
            restart: always
      
      cfnat3:
            container_name: mycfnat
            image: cmliu/cfnat:latest
            environment:
                  - colo=SJC,LAX  # 筛选数据中心例如 HKG,SJC,LAX.电信/联通 推荐 SJC,LAX.移动/广电 推荐 HKG
                  - delay=300  # 有效延迟（毫秒），超过此延迟将断开连接
                  #- ips=4  # 指定生成IPv4还是IPv6地址
                  - port=443  # 转发的目标端口
                  #- tls=true  # 是否为 TLS 端口
                  #- random=true  # 是否随机生成IP，如果为false，则从CIDR中拆分出所有IP
                  #- ipnum=10  # 提取的有效IP数量
                  #- num=10  # 目标负载 IP 数量
                  - task=64  # 并发请求最大协程数
                  #- code=200  # HTTP/HTTPS 响应状态码
                  #- domain=cloudflaremirrors.com/debian # 响应状态码检查的域名地址
            ports:
                  - "1234:1234"  # 将主机的 1234 端口映射到容器的 1234 端口
            restart: always
```

## 查看日志
```shell
# 查看cfnat容器执行日志
docker logs 容器ID
docker logs -f 容器ID    # 实时查看日志

# 查看cfnat容器启动日志
docker exec 容器ID cat cfnat.log
```


## 参数说明
```
  -code int
        HTTP/HTTPS 响应状态码 (default 200)
  -colo string
        数据中心: 筛选数据中心例如 HKG,SJC,LAX (多个数据中心用逗号隔开,留空则忽略匹配)
  -delay int
        有效延迟（毫秒）: 超过此延迟将断开连接 (default 300)
  -domain string
        响应状态码检查的域名地址 (default "cloudflaremirrors.com/debian")
  -ipnum int
        有效IP数: 提取的有效IP数量 (default 20)
  -ips string
        转发IP类型: 指定生成IPv4还是IPv6地址 (4或6) (default "4")
  -num int
        负载IP数: 目标负载 IP 数量 (default 10)
  -port int
        转发目标端口 (default 443)
  -random
        是否随机生成IP，如果为false，则从CIDR中拆分出所有IP (default true)
  -tls
        是否为 TLS 端口 (default true)
  -task int
        最大并发请求数: 并发请求最大协程数 (default 100)
```

## 创建 `docker-compose.yml`
```yml

version: '3'

services:
  cfnat:
    container_name: mycfnat
    image: cynyy0126/cfnat:latest
    network_mode: host
    environment:
      - colo=HKG  # 筛选数据中心例如 HKG,SJC,LAX.电信/联通 推荐 SJC,LAX.移动/广电 推荐 HKG"
      - delay=100  # 有效延迟（毫秒），超过此延迟将断开连接
      - LISTEN_PORT=2345 #默认1234 默认留空
      - ips=4  # 指定生成IPv4还是IPv6地址
      - port=443  # 转发的目标端口
      - tls=true  # 是否为 TLS 端口
      - random=true  # 是否随机生成IP，如果为false，则从CIDR中拆分出所有IP
      - ipnum=10  # 提取的有效IP数量
      - num=10  # 目标负载 IP 数量
      - task=100  # 并发请求最大协程数
      - code=200  # HTTP/HTTPS 响应状态码
      - domain=cloudflaremirrors.com/debian # 响应状态码检查的域名地址
    #ports:
     # - "1234:1234"  # 将主机的 1234 端口映射到容器的 1234 端口
    restart: always
```


# 致谢
[gdfsnhsw](https://github.com/gdfsnhsw/CFnat-Docker)、[股神](https://t.me/CF_NAT/38840)、ChatGPT






