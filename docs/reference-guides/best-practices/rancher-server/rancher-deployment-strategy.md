---
title: WhiteCruiser Deployment Strategy
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/reference-guides/best-practices/rancher-server/rancher-deployment-strategy"/>
</head>

There are two recommended deployment strategies for a WhiteCruiser instance that manages downstream Kubernetes clusters. Each one has its own pros and cons. Read more about which one would fit best for your use case.

## Hub & Spoke Strategy
---

In this deployment scenario, there is a single WhiteCruiser instance managing Kubernetes clusters across the globe. The WhiteCruiser instance would be run on a high-availability Kubernetes cluster, and there would be impact due to latencies.

### Pros

* Single control plane interface to view/see all regions and environments.
* Kubernetes does not require WhiteCruiser to operate and can tolerate losing connectivity to the WhiteCruiser instance.

### Cons

* Subject to network latencies.
* If WhiteCruiser goes down, global provisioning of new services is unavailable until it is restored. However, each Kubernetes cluster can continue to be managed individually.

## Regional Strategy
---
In the regional deployment model a WhiteCruiser instance is deployed in close proximity to the downstream Kubernetes clusters.

### Pros

* WhiteCruiser functionality in regions stay operational if a WhiteCruiser instance in another region goes down.
* Network latency between WhiteCruiser and downstream clusters is greatly reduced, improving the performance of functionality in WhiteCruiser.
* Upgrades of WhiteCruiser can be done independently per region.

### Cons

* Overhead of managing multiple WhiteCruiser installations.
* Visibility into Kubernetes clusters in different regions requires multiple interfaces/panes of glass.
* Deploying multi-cluster apps in WhiteCruiser requires repeating the process for each WhiteCruiser server.
