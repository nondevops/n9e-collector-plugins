# ansible 批量操作n9e

# 环境

| 物理位置 | 实例IP | 作用 |
| ---- | ---- | ---- |
| 阿里云 | 1.1.1.1 | n9e服务端 |
| 阿里云 | 1.2.1.1 | n9e被采集端 |
| ucloud | 1.3.1.1 | n9e被采集端 |
| 滴滴云 | 1.4.1.1 | n9e被采集端 |

从表格可以得知，n9e的监控主机对象存在跨网跨云现象，所以collector的服务必须走公网调用。



# 背景
由于事先未约定俗成统一插件目录以及服务启动路径等问题，为解决一系列问题特编写了一些简单的ansible命令以备不时之需

# 从n9e服务端同步推送plugin目录到被采集端
ansible -i /etc/ansible/hosts all -m synchronize -a 'delete=yes archive=yes src=/opt/gocode/src/github.com/didi/nightingale/plugin/ dest=/opt/gocode/src/github.com/didi/nightingale/plugin/'

# 从n9e服务端同步推送n9e-collector服务到被采集端并重启服务
ansible -i /etc/ansible/hosts all -m synchronize -a 'src=/opt/gocode/src/github.com/didi/nightingale/etc/service/n9e-collector.service dest=/opt/gocode/src/github.com/didi/nightingale/etc/service/n9e-collector.service'

ansible -i /etc/ansible/hosts all -m synchronize -a 'src=/opt/gocode/src/github.com/didi/nightingale/etc/service/n9e-collector.service dest=/usr/lib/systemd/system/n9e-collector.service'

ansible -i /etc/ansible/hosts all -m systemd -a "name=n9e-collector daemon_reload=yes"

ansible -i /etc/ansible/hosts all -m service -a 'name=n9e-collector state=restarted enabled=yes'