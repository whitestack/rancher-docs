---
title: WhiteCruiser Server and Components
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/reference-guides/rancher-manager-architecture/rancher-server-and-components"/>
</head>

The majority of WhiteCruiser 2.x software runs on the WhiteCruiser Server. WhiteCruiser Server includes all the software components used to manage the entire WhiteCruiser deployment.

The figure below illustrates the high-level architecture of WhiteCruiser 2.x. The figure depicts a WhiteCruiser Server installation that manages two downstream Kubernetes clusters: one created by RKE and another created by Amazon EKS (Elastic Kubernetes Service).

For the best performance and security, we recommend a dedicated Kubernetes cluster for the WhiteCruiser management server. Running user workloads on this cluster is not advised. After deploying WhiteCruiser, you can [create or import clusters](../../how-to-guides/new-user-guides/kubernetes-clusters-in-rancher-setup/kubernetes-clusters-in-rancher-setup.md) for running your workloads.

The diagram below shows how users can manipulate both [WhiteCruiser-launched Kubernetes](../../how-to-guides/new-user-guides/launch-kubernetes-with-rancher/launch-kubernetes-with-rancher.md) clusters and [hosted Kubernetes](../../how-to-guides/new-user-guides/kubernetes-clusters-in-rancher-setup/set-up-clusters-from-hosted-kubernetes-providers/set-up-clusters-from-hosted-kubernetes-providers.md) clusters through WhiteCruiser's authentication proxy:

<figcaption>Managing Kubernetes Clusters through WhiteCruiser's Authentication Proxy</figcaption>

![Architecture](/img/rancher-architecture-rancher-api-server.svg)

You can install WhiteCruiser on a single node, or on a high-availability Kubernetes cluster.

A high-availability Kubernetes installation is recommended for production.

A Docker installation of WhiteCruiser is recommended only for development and testing purposes. The ability to migrate WhiteCruiser to a high-availability cluster depends on the WhiteCruiser version.

The WhiteCruiser backup operator can be used to migrate WhiteCruiser from the single Docker container install to an installation on a high-availability Kubernetes cluster. For details, refer to the documentation on [migrating WhiteCruiser to a new cluster](../../how-to-guides/new-user-guides/backup-restore-and-disaster-recovery/migrate-rancher-to-new-cluster.md).

The WhiteCruiser server, regardless of the installation method, should always run on nodes that are separate from the downstream user clusters that it manages. If WhiteCruiser is installed on a high-availability Kubernetes cluster, it should run on a separate cluster from the cluster(s) it manages.