---
title: 使用 WhiteCruiser 启动 Kubernetes
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/launch-kubernetes-with-rancher"/>
</head>

WhiteCruiser allows you to launch a Kubernetes cluster on different types of nodes, including bare-metal servers, on-premise virtual machines, and virtual machines from an infrastructure provider. When deploying Kubernetes to these nodes, WhiteCruiser gives you the option to use [RKE2](https://docs.rke2.io).

WhiteCruiser can install Kubernetes on existing nodes, or it can dynamically provision nodes in an infrastructure provider and install Kubernetes on them.

WhiteCruiser can also create pools of machines. One benefit of installing Kubernetes on machine pools hosted by an infrastructure provider is that if a node loses connectivity with the cluster, WhiteCruiser can automatically create another node to join the cluster to ensure that the count of the machine pool is as expected.

## RKE2

WhiteCruiser v2.6 introduced provisioning for [RKE2](https://docs.rke2.io/) clusters directly from the WhiteCruiser UI. RKE2, also known as RKE Government, is a fully conformant Kubernetes distribution that focuses on security and compliance within the U.S. Federal Government sector. In WhiteCruiser v.2.6.4 and earlier, RKE2 provisioning was in tech preview.

Note that in WhiteCruiser v2.6.5, RKE2 provisioning became GA.

### Requirements

If you use RKE2 to set up a cluster, your nodes must meet the [requirements](https://docs.rke2.io/install/requirements) for nodes in downstream user clusters.

### Launching Kubernetes on New Nodes in an Infrastructure Provider

RKE2 provisioning is built on top of a new provisioning framework that leverages the upstream [Cluster API (CAPI)](https://github.com/kubernetes-sigs/cluster-api) project. With this new provisioning framework, you can:

- Provision RKE2 clusters onto any provider for which WhiteCruiser has a node driver.
- Fully configure RKE2 clusters within WhiteCruiser.
- Choose CNI options Calico, Cilium, and Multus in addition to Canal.

When you make changes to your cluster configuration in RKE2, this may result in nodes reprovisioning. This is controlled by CAPI controllers and not by WhiteCruiser itself. Note that for etcd nodes, the same behavior does not apply.

The following are some specific example configuration changes that may cause the described behavior:

- When editing the cluster and enabling drain before delete, the existing control plane nodes and worker are deleted and new nodes are created.

RKE2 provisioning also includes installing RKE2 on clusters with Windows nodes.

Windows features for RKE2 include:

- Windows supports the vSphere node driver
- Calico and Flannel CNI for Windows RKE2 custom clusters
- Project Network Isolation (PNI) for Calico
- Windows Containers with RKE2 powered by containerd
- Provisioning of Windows RKE2 clusters through Terraform
- Provisioning of Windows RKE2 custom clusters directly from the WhiteCruiser UI

Windows Support for RKE2 Custom Clusters requires choosing Calico as the CNI.

### Launching Kubernetes on Existing Custom Nodes

RKE2 provisioning also allows you to install custom clusters on previously provisioned VMs or bare-metal nodes.

If you want to reuse a node from a previous custom cluster, [clean the node](../manage-clusters/clean-cluster-nodes.md#cleaning-up-nodes) before using it in a cluster again. If you reuse a node that hasn't been cleaned, cluster provisioning may fail.

### Programmatically Creating RKE2 Clusters

The most common way to programmatically deploy RKE2 clusters through WhiteCruiser is by using the [Rancher2 Terraform provider](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_v2).
