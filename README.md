# Learning Env

[![Docker Repository on Quay](https://quay.io/repository/goiiot/learning-env/status "Docker Repository on Quay")](https://quay.io/repository/goiiot/learning-env)

Linux learning environment for noob

## What's in the environment


- OS - Ubuntu 18.04
- Software
    - `git`
    - `tmux`
    - `vim`
    - `nodejs` and `npm`
    - `htop`
    - `gotop`
    - `tldr`
    - `GCC Toolchain`

## Usage

Using this environment requires `Docker` installation, refer to [https://docs.docker.com/install/](https://docs.docker.com/install/) for help, after you have installed `Docker` on your machine, you can run following command to get started

```bash
$ docker run -it learning-env:test
```

## Lab member

If you have already been a member of our lab, we provide cloud learning environment on top of our `Kubernetes` cluster, please install [`Termius`](https://www.termius.com/) and contact our cluster manager for member access.
