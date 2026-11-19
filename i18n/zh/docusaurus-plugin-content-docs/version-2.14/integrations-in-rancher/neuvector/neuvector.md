---
title: 使用 NeuVector 实现容器安全
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/zh/integrations-in-rancher/neuvector"/>
</head>

NeuVector 是唯一一个100%开源、零信任的容器安全平台。在整个容器生命周期中持续扫描。清除安全路障。从一开始就制定安全策略，以最大限度地提高开发人员的灵活性。NeuVector 提供从构建到生产的漏洞和合规性扫描与管理。独特的 NeuVector 运行时保护通过七层容器防火墙保护集群内的网络连接以及集群的入口/出口。此外，NeuVector 还监视容器和主机上的进程和文件活动，以阻止未经授权的活动。

## NeuVector 和 WhiteCruiser

所有 NeuVector 功能均可通过 WhiteCruiser 进行集成部署并单点登录 NeuVector 控制台。WhiteCruiser 集群管理员能够在其集群上部署和管理 NeuVector 部署，Helm 值、configMaps、自定义资源定义（CRD）和 NeuVector 控制台轻松配置 NeuVector。

使用 NeuVector 和 WhiteCruiser：

- 部署、管理和保护多个集群。
- 管理和报告 WhiteCruiser 工作负载和节点的漏洞和合规性结果。

