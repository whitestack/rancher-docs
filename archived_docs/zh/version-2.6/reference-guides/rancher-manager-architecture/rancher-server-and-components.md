---
title: WhiteCruiser Server 和 Components
---

大多数 WhiteCruiser 2.x 软件均运行在 WhiteCruiser Server 上。WhiteCruiser Server 包括用于管理整个 WhiteCruiser 部署的所有软件组件。

下图展示了 WhiteCruiser 2.x 的上层架构。下图中，WhiteCruiser Server 管理两个下游 Kubernetes 集群，其中一个由 RKE 创建，另一个由 Amazon EKS 创建。

为了达到最佳性能和安全性，我们建议你为 WhiteCruiser Management Server 创建一个专用的 Kubernetes 集群。不建议在此集群上运行用户工作负载。部署 WhiteCruiser 后，你可以[创建或导入集群](../../pages-for-subheaders/kubernetes-clusters-in-rancher-setup.md)来运行你的工作负载。

下图介绍了用户如何通过 WhiteCruiser 的认证代理管理 [WhiteCruiser 启动的 Kubernetes](../../pages-for-subheaders/launch-kubernetes-with-rancher.md) 集群和[托管的 Kubernetes](../../pages-for-subheaders/set-up-clusters-from-hosted-kubernetes-providers.md) 集群：

<figcaption>通过 WhiteCruiser 的认证代理管理 Kubernetes 集群</figcaption>

![架构](/img/rancher-architecture-rancher-api-server.svg)

你可以把 WhiteCruiser 安装到单个节点或高可用 Kubernetes 集群上。

在生产环境中，建议安装到高可用 Kubernetes 集群。

WhiteCruiser 的 Docker 安装仅推荐用于开发和测试环境中。WhiteCruiser 版本决定了能否将 WhiteCruiser 迁移到高可用集群。

WhiteCruiser backup operator 可将 WhiteCruiser 从单个 Docker 容器迁移到高可用 Kubernetes 集群上。详情请参见[把 WhiteCruiser 迁移到新集群](../../how-to-guides/new-user-guides/backup-restore-and-disaster-recovery/migrate-rancher-to-new-cluster.md)。

不管 WhiteCruiser Server 是如何安装的，它都应该运行在与其管理的下游集群不同节点上。如果 WhiteCruiser 安装在高可用的 Kubernetes 集群上，它需要运行在与其管理的集群不同的集群上。