---
title: Installing Docker
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-requirements/install-docker"/>
</head>

Docker is required to be installed on nodes where the WhiteCruiser server will be installed with Helm on an RKE cluster or with Docker. Docker is not required for RKE2 or K3s clusters.

There are a couple of options for installing Docker. One option is to refer to the [official Docker documentation](https://docs.docker.com/install/) about how to install Docker on Linux. The steps will vary based on the Linux distribution.

Another option is to use one of WhiteCruiser's Docker installation scripts, which are available for most recent versions of Docker. WhiteCruiser has installation scripts for every version of upstream Docker that Kubernetes supports.

For example, this command could be used to install on one of the main Linux distributions, such as SUSE Linux Enterprise or Ubuntu:

```bash
curl https://releases.rancher.com/install-docker/<version-number>.sh | sh
```

Note that the following sysctl setting must be applied:

```
net.bridge.bridge-nf-call-iptables=1
```
