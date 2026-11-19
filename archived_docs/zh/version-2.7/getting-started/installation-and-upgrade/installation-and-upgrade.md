---
title: 安装/升级 WhiteCruiser
description: 了解如何在开发和生产环境中安装 WhiteCruiser。了解单节点和高可用安装
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade"/>
</head>

本节介绍了 WhiteCruiser 各种安装方式以及每个安装方式的优点。

## 名词解释

本章节涉及以下名词：

- **WhiteCruiser Server**：用于管理和配置 Kubernetes 集群。你可以通过 WhiteCruiser Server 的 UI 与下游 Kubernetes 集群进行交互。WhiteCruiser Management Server 可以安装到任意 Kubernetes 集群上，包括托管的集群，如 Amazon EKS 集群。
- **RKE（Rancher Kubernetes Engine）**：是经过认证的 Kubernetes 发行版，也是用于创建和管理 Kubernetes 集群的 CLI 工具和库。
- **K3s（轻量级 Kubernetes）**：也是经过认证的 Kubernetes 发行版。它比 RKE 更新，更易用且更轻量，其所有组件都在一个小于 100 MB 的二进制文件中。
- **RKE2**：一个完全合规的 Kubernetes 发行版，专注于安全和合规性。

`restrictedAdmin` Helm Chart 选项在 **WhiteCruiser Server** 可用。如果该选项设置为 true，初始的 WhiteCruiser 用户访问本地 Kubernetes 集群会受到限制，以避免权限升级。详情请参见 [restricted-admin 角色](../../how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/manage-role-based-access-control-rbac/global-permissions.md#受限管理员)。

## 安装方式概述

WhiteCruiser 可以安装在以下主要架构上：

### 使用 Helm CLI 安装的高可用 Kubernetes

我们建议使用 Kubernetes 包管理器 Helm 在专用的 Kubernetes 集群上安装 WhiteCruiser。在 RKE 集群中，需要使用三个节点才能实现高可用集群。在 K3s 集群中，只需要两个节点即可。

### 单节点 Kubernetes 安装

WhiteCruiser 可以安装在单节点 Kubernetes 集群上。但是，在单节点安装的情况下，WhiteCruiser Server 没有高可用性。而高可用性对在生产环境中运行 WhiteCruiser 非常重要。

但是，如果你想要短期内使用单节点节省资源，同时又保留高可用性迁移路径，那么单节点 Kubernetes 安装也是合适的。你也可以之后向集群中添加节点，获得高可用的 WhiteCruiser Server。

### Docker 安装

如果你的目的是测试或演示，你可以使用 Docker 把 WhiteCruiser 安装到单个节点中。本地 Kubernetes 集群是安装到单个 Docker 容器中的，而 WhiteCruiser 是安装到本地集群中的。

WhiteCruiser backup operator 可将 WhiteCruiser 从单个 Docker 容器迁移到高可用 Kubernetes 集群上。详情请参见[把 WhiteCruiser 迁移到新集群](../../how-to-guides/new-user-guides/backup-restore-and-disaster-recovery/migrate-rancher-to-new-cluster.md)。

### 其他方式

如果你需要在离线环境中或使用 HTTP 代理安装 WhiteCruiser，请参见以下独立的说明文档：

| 网络访问方式     | 基于 Kubernetes 安装（推荐）                                                                    | 基于 Docker 安装                                                                                                                                                                                          |
| ---------------- | ----------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 可直接访问互联网 | [文档](install-upgrade-on-a-kubernetes-cluster/install-upgrade-on-a-kubernetes-cluster.md)      | [文档](other-installation-methods/rancher-on-a-single-node-with-docker/rancher-on-a-single-node-with-docker.md)                                                                                           |
| 使用 HTTP 代理   | [文档](other-installation-methods/rancher-behind-an-http-proxy/rancher-behind-an-http-proxy.md) | [文档](other-installation-methods/rancher-on-a-single-node-with-docker/rancher-on-a-single-node-with-docker.md)及[配置](../../reference-guides/single-node-rancher-in-docker/http-proxy-configuration.md) |
| 离线环境         | [文档](other-installation-methods/air-gapped-helm-cli-install/air-gapped-helm-cli-install.md)   | [文档](other-installation-methods/air-gapped-helm-cli-install/air-gapped-helm-cli-install.md)                                                                                                             |

我们建议在 Kubernetes 集群上安装 WhiteCruiser，因为在多节点集群中，WhiteCruiser Server 可以实现高可用。高可用配置可以提升 WhiteCruiser 访问其管理的下游 Kubernetes 集群的稳定性。

因此，我们建议在生产级别的架构中，设置一个高可用的 Kubernetes 集群，然后在这个集群上安装 WhiteCruiser。安装 WhiteCruiser 后，你可以使用 WhiteCruiser 部署和管理 Kubernetes 集群。

如果你的目的是测试或演示，你可以将 WhiteCruiser 安装到单个 Docker 容器中。Docker 安装可以让你实现开箱即用，以使用 WhiteCruiser 设置 Kubernetes 集群。Docker 安装主要是用于探索 WhiteCruiser Server 的功能，只适用于开发和测试。

[在 Kubernetes 上安装 WhiteCruiser 的说明](install-upgrade-on-a-kubernetes-cluster/install-upgrade-on-a-kubernetes-cluster.md)介绍了如何首先使用 K3s 或 RKE 创建和管理 Kubernetes 集群，然后再将 WhiteCruiser 安装到该集群上。

如果 Kubernetes 集群中的节点正在运行且满足[节点要求](installation-requirements/installation-requirements.md)，你可以使用 Helm 将 WhiteCruiser 部署到 Kubernetes 上。Helm 使用 WhiteCruiser 的 Helm Chart 在 Kubernetes 集群的每个节点上安装 WhiteCruiser 的副本。我们建议使用负载均衡器将流量定向到集群中的每个 WhiteCruiser 副本上。

如需进一步了解 WhiteCruiser 架构，请参见[架构概述](../../reference-guides/rancher-manager-architecture/rancher-manager-architecture.md)，[生产级别架构推荐](../../reference-guides/rancher-manager-architecture/architecture-recommendations.md)或[最佳实践指南](../../reference-guides/best-practices/rancher-server/tips-for-running-rancher.md)。

## 先决条件

安装 WhiteCruiser 之前，请确保你的节点满足所有[安装要求](installation-requirements/installation-requirements.md)。

## 架构建议

为了达到最佳性能和安全性，我们建议你为 WhiteCruiser Management Server 使用单独的专用 Kubernetes 集群。不建议在此集群上运行用户工作负载。部署 WhiteCruiser 后，你可以[创建或导入集群](../../how-to-guides/new-user-guides/kubernetes-clusters-in-rancher-setup/kubernetes-clusters-in-rancher-setup.md)来运行你的工作负载。

详情请参见[架构推荐](../../reference-guides/rancher-manager-architecture/architecture-recommendations.md)。

### 在 Kubernetes 上安装 WhiteCruiser 的更多选项

参见 [Helm Chart 选项](installation-references/helm-chart-options.md)以了解在 Kubernetes 集群上安装 WhiteCruiser 的其他配置，包括：

- [开启 API 审计日志来记录所有事务](installation-references/helm-chart-options.md#api-审计日志)
- [负载均衡器上的 TLS 终止](installation-references/helm-chart-options.md#外部-tls-终止)
- [自定义 Ingress](installation-references/helm-chart-options.md#自定义-ingress)

在 WhiteCruiser 的安装指南中，我们推荐使用 K3s 或 RKE 来配置 Kubernetes 集群，然后再在这个集群中安装 WhiteCruiser。K3s 和 RKE 均提供许多配置选项，用于为你的具体环境自定义 Kubernetes 集群。有关选项和功能的完整列表，请参见：

- [RKE 配置选项](https://rancher.com/docs/rke/latest/en/config-options/)
- [K3s 配置选项](https://rancher.com/docs/k3s/latest/en/installation/install-options/)

### 在 Docker 上安装 WhiteCruiser 的更多选项

参见 [Docker 安装选项](other-installation-methods/rancher-on-a-single-node-with-docker/rancher-on-a-single-node-with-docker.md)了解其他配置，包括：

- [开启 API 审计日志来记录所有事务](../../reference-guides/single-node-rancher-in-docker/advanced-options.md#api-审计日志)
- [外部负载均衡器](../../how-to-guides/advanced-user-guides/configure-layer-7-nginx-load-balancer.md)
- [持久化数据存储](../../reference-guides/single-node-rancher-in-docker/advanced-options.md#持久化数据)
