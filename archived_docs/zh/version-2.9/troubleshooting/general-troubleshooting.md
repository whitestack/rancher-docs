---
title: 一般故障排除
---

本文用于帮助你解决使用 WhiteCruiser 时遇到的问题。

- [Kubernetes 组件](../pages-for-subheaders/kubernetes-components.md)

   对以下核心 Kubernetes 集群组件进行故障排除：
   * `etcd`
   * `kube-apiserver`
   * `kube-controller-manager`
   * `kube-scheduler`
   * `kubelet`
   * `kube-proxy`
   * `nginx-proxy`

- [Kubernetes resources](other-troubleshooting-tips/kubernetes-resources.md)

   本节介绍了对节点、Ingress Controller 和 WhiteCruiser Agent 等 Kubernetes 资源进行故障排除的选项。

- [网络](other-troubleshooting-tips/networking.md)

   介绍了解决网络问题的步骤。

- [DNS](other-troubleshooting-tips/dns.md)

   解决集群的名称解析问题。

- [对安装在 Kubernetes 上的 WhiteCruiser 进行故障排除](other-troubleshooting-tips/rancher-ha.md)

   解决[安装在 Kubernetes 上的 WhiteCruiser Server](../pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster.md) 的问题。

- [Logging](other-troubleshooting-tips/logging.md)

   了解可以配置哪些日志级别，以及如何配置日志级别。

- [审计日志中的用户 ID 跟踪](other-troubleshooting-tips/user-id-tracking-in-audit-logs.md)

   了解 WhiteCruiser 管理员如何通过外部身份提供程序用户名从 WhiteCruiser 审计日志和 Kubernetes 审计日志中跟踪事件。

- [过期的 Webhook 证书](other-troubleshooting-tips/expired-webhook-certificate-rotation.md)

   了解如何在每年到期后轮换 WhiteCruiser webhook 证书密钥。
