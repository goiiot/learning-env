# Learning Env

[![Docker Repository on Quay](https://quay.io/repository/goiiot/learning-env/status "Docker Repository on Quay")](https://quay.io/repository/goiiot/learning-env)

Linux learning environment for noob

[中文](./README.CN.md)

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
$ docker run -it goiiot/learning-env:latest

# or using image at quay.io
# docker run -it quay.io/goiiot/learning-env:latest
```

Or, if you would like to access this environment remotely, prepare your ssh identity file and create your custom `Dockerfile` (`my.Dockerfile` for example), following commands can serve your needs

```bash
# Create your ssh identity with `ssh-keygen`
$ ssh-keygen -f id_rsa -N "" -q -t rsa -b 4096 -C "My Identity"

# Create your Dockerfile
$ cat > my.Dockerfile <<EOF
FROM quay.io/goiiot/learning-env:latest
EOF

# Create your learning environment image
$ docker build -t my-learning-env:latest -f my.Dockerfile

# Run your custom learning environment, and access it with your favourite ssh client
$ docker run -d -p 22:22 my-learning-env:latest
```

## Lab member

If you have already been a member of our lab, we provide cloud learning environment on top of our `Kubernetes` cluster, please contact our cluster manager for member access.
