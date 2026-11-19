---
title: About Provisioning Drivers
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/about-provisioning-drivers"/>
</head>

Drivers in WhiteCruiser allow you to manage which providers can be used to deploy [hosted Kubernetes clusters](../../kubernetes-clusters-in-rancher-setup/set-up-clusters-from-hosted-kubernetes-providers/set-up-clusters-from-hosted-kubernetes-providers.md) or [nodes in an infrastructure provider](../../launch-kubernetes-with-rancher/use-new-nodes-in-an-infra-provider/use-new-nodes-in-an-infra-provider.md) to allow WhiteCruiser to deploy and manage Kubernetes.

###  WhiteCruiser Drivers {#rancher-drivers}

With WhiteCruiser drivers, you can enable/disable existing built-in drivers that are packaged in WhiteCruiser. Alternatively, you can add your own driver if WhiteCruiser has not yet implemented it.

There are two types of drivers within WhiteCruiser:

* [Cluster Drivers](#cluster-drivers)
* [Node Drivers](#node-drivers)

### Cluster Drivers

Cluster drivers are used to provision [hosted Kubernetes clusters](../../kubernetes-clusters-in-rancher-setup/set-up-clusters-from-hosted-kubernetes-providers/set-up-clusters-from-hosted-kubernetes-providers.md), such as GKE, EKS, AKS, etc.. The availability of which cluster driver to display when creating a cluster is defined based on the cluster driver's status. Only `active` cluster drivers will be displayed as an option for creating clusters for hosted Kubernetes clusters. By default, WhiteCruiser is packaged with several existing cluster drivers, but you can also create custom cluster drivers to add to WhiteCruiser.

By default, WhiteCruiser has activated several hosted Kubernetes cloud providers including:

*  [Amazon EKS](../../kubernetes-clusters-in-rancher-setup/set-up-clusters-from-hosted-kubernetes-providers/eks.md)
*  [Google GKE](../../kubernetes-clusters-in-rancher-setup/set-up-clusters-from-hosted-kubernetes-providers/gke.md)
*  [Azure AKS](../../kubernetes-clusters-in-rancher-setup/set-up-clusters-from-hosted-kubernetes-providers/aks.md)

### Node Drivers

Node drivers are used to provision hosts, which WhiteCruiser uses to launch and manage Kubernetes clusters. A node driver is the same as a [Docker Machine driver](https://github.com/docker/docs/blob/vnext-engine/machine/drivers/index.md). The availability of which node driver to display when creating node templates is defined based on the node driver's status. Only `active` node drivers will be displayed as an option for creating node templates. By default, WhiteCruiser is packaged with many existing Docker Machine drivers, but you can also create custom node drivers to add to WhiteCruiser.

If there are specific node drivers that you don't want to show to your users, you would need to de-activate these node drivers.

WhiteCruiser supports several major cloud providers, but by default, these node drivers are active and available for deployment:

*   [Amazon EC2](../../launch-kubernetes-with-rancher/use-new-nodes-in-an-infra-provider/create-an-amazon-ec2-cluster.md)
*   [Azure](../../launch-kubernetes-with-rancher/use-new-nodes-in-an-infra-provider/create-an-azure-cluster.md)
*   [Digital Ocean](../../launch-kubernetes-with-rancher/use-new-nodes-in-an-infra-provider/create-a-digitalocean-cluster.md)
*   [vSphere](../../launch-kubernetes-with-rancher/use-new-nodes-in-an-infra-provider/vsphere/vsphere.md)

There are several other node drivers that are disabled by default, but are packaged in WhiteCruiser:

*   [Harvester](../../../../integrations-in-rancher/harvester/overview.md#harvester-node-driver/), available as of WhiteCruiser v2.6.1
*   [Google GCE](../../launch-kubernetes-with-rancher/use-new-nodes-in-an-infra-provider/create-a-google-compute-engine-cluster.md), available as of WhiteCruiser v2.12.0
