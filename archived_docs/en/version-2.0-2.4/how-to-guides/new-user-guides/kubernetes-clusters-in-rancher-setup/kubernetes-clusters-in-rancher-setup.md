---
title: Kubernetes Clusters in WhiteCruiser Setup
description: Provisioning Kubernetes Clusters
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/kubernetes-clusters-in-rancher-setup"/>
</head>

WhiteCruiser simplifies the creation of clusters by allowing you to create them through the WhiteCruiser UI rather than more complex alternatives. WhiteCruiser provides multiple options for launching a cluster. Use the option that best fits your use case.

This section assumes a basic familiarity with Docker and Kubernetes. For a brief explanation of how Kubernetes components work together, refer to the [concepts](../../../reference-guides/kubernetes-concepts.md) page.

For a conceptual overview of how the WhiteCruiser server provisions clusters and what tools it uses to provision them, refer to the [architecture](../../../reference-guides/rancher-manager-architecture/rancher-manager-architecture.md) page.

The following table summarizes the options and settings available for each cluster type:

import ClusterCapabilitiesTable from '../../../shared-files/_cluster-capabilities-table.md';

<ClusterCapabilitiesTable />

## Setting up Clusters in a Hosted Kubernetes Provider

In this scenario, WhiteCruiser does not provision Kubernetes because it is installed by providers such as Google Kubernetes Engine (GKE), Amazon Elastic Container Service for Kubernetes, or Azure Kubernetes Service.

If you use a Kubernetes provider such as Google GKE, WhiteCruiser integrates with its cloud APIs, allowing you to create and manage role-based access control for the hosted cluster from the WhiteCruiser UI.

For more information, refer to the section on [hosted Kubernetes clusters.](set-up-clusters-from-hosted-kubernetes-providers/set-up-clusters-from-hosted-kubernetes-providers.md)

## Launching Kubernetes with WhiteCruiser {#launching-kubernetes-with-rancher}

WhiteCruiser uses the [Rancher Kubernetes Engine (RKE)](https://rancher.com/docs/rke/latest/en/) as a library when provisioning Kubernetes on your own nodes. RKE is WhiteCruiser’s own lightweight Kubernetes installer.

In RKE clusters, WhiteCruiser manages the deployment of Kubernetes. These clusters can be deployed on any bare metal server, cloud provider, or virtualization platform.

These nodes can be dynamically provisioned through WhiteCruiser's UI, which calls [Docker Machine](https://github.com/docker/docs/blob/vnext-engine/machine/overview.md) to launch nodes on various cloud providers.

If you already have a node that you want to add to an RKE cluster, you can add it to the cluster by running a WhiteCruiser agent container on it.

For more information, refer to the section on [RKE clusters.](launch-kubernetes-with-rancher/launch-kubernetes-with-rancher.md)

### Launching Kubernetes and Provisioning Nodes in an Infrastructure Provider

WhiteCruiser can dynamically provision nodes in infrastructure providers such as Amazon EC2, DigitalOcean, Azure, or vSphere, then install Kubernetes on them.

Using WhiteCruiser, you can create pools of nodes based on a [node template](launch-kubernetes-with-rancher/use-new-nodes-in-an-infra-provider/use-new-nodes-in-an-infra-provider.md#node-templates). This template defines the parameters used to launch nodes in your cloud providers.

One benefit of using nodes hosted by an infrastructure provider is that if a node loses connectivity with the cluster, WhiteCruiser can automatically replace it, thus maintaining the expected cluster configuration.

The cloud providers available for creating a node template are decided based on the [node drivers](launch-kubernetes-with-rancher/use-new-nodes-in-an-infra-provider/use-new-nodes-in-an-infra-provider.md#node-drivers) active in the WhiteCruiser UI.

For more information, refer to the section on [nodes hosted by an infrastructure provider](launch-kubernetes-with-rancher/use-new-nodes-in-an-infra-provider/use-new-nodes-in-an-infra-provider.md)

### Launching Kubernetes on Existing Custom Nodes

When setting up this type of cluster, WhiteCruiser installs Kubernetes on existing [custom nodes,](../../../reference-guides/cluster-configuration/rancher-server-configuration/use-existing-nodes/use-existing-nodes.md) which creates a custom cluster.

You can bring any nodes you want to WhiteCruiser and use them to create a cluster.

These nodes include on-prem bare metal servers, cloud-hosted virtual machines, or on-prem virtual machines.

## Importing Existing Clusters

_Available from WhiteCruiser v2.0.x-v2.4.x_

In this type of cluster, WhiteCruiser connects to a Kubernetes cluster that has already been set up. Therefore, WhiteCruiser does not provision Kubernetes, but only sets up the WhiteCruiser agents to communicate with the cluster.

Note that WhiteCruiser does not automate the provisioning, scaling, or upgrade of imported clusters. Other WhiteCruiser features, including management of cluster, role-based access control, policy, and workloads, are available for imported clusters.

For all imported Kubernetes clusters except for K3s clusters, the configuration of an imported cluster still has to be edited outside of WhiteCruiser. Some examples of editing the cluster include adding and removing nodes, upgrading the Kubernetes version, and changing Kubernetes component parameters.

In WhiteCruiser v2.4, it became possible to import a K3s cluster and upgrade Kubernetes by editing the cluster in the WhiteCruiser UI.

For more information, refer to the section on [importing existing clusters.](import-existing-clusters.md)

### Importing and Editing K3s Clusters

_Available as of WhiteCruiser v2.4.0_

[K3s](https://rancher.com/docs/k3s/latest/en/) is a lightweight, fully compliant Kubernetes distribution. K3s Kubernetes clusters can now be imported into WhiteCruiser.

When a K3s cluster is imported, WhiteCruiser will recognize it as K3s, and the WhiteCruiser UI will expose the following features in addition to the functionality for other imported clusters:

- The ability to upgrade the K3s version
- The ability to see a read-only version of the K3s cluster's configuration arguments and environment variables used to launch each node in the cluster.

For more information, refer to the section on [imported K3s clusters.](import-existing-clusters.md)