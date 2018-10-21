# Learning Env

[![Docker Repository on Quay](https://quay.io/repository/goiiot/learning-env/status "Docker Repository on Quay")](https://quay.io/repository/goiiot/learning-env)

实验室新人 Linux 学习环境

## 包含什么东西

- 系统 - Ubuntu 18.04
- 软件
    - `git`
    - `tmux`
    - `vim`
    - `nodejs` 和 `npm`
    - `htop`
    - `gotop`
    - `tldr`
    - `GCC 工具链`

## 用法

使用该学习环境需要安装有 `Docker`, 参考 [https://docs.docker.com/install/](https://docs.docker.com/install/) 获得帮助, 装好 `Docker` 之后, 可以运行如下命令开始

```bash
$ docker run -it goiiot/learning-env:latest

# 或者使用在 quay.io 上的镜像
# docker run -it quay.io/goiiot/learning-env:latest
```

## 实验室成员

如果你已经是实验室的一员了, 我们提供基于我们自己的 `Kubernetes` 集群的云学习环境, 请联系我们的集群管理员获取接入许可
