---
title: About High-availability Installations
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/kubernetes-cluster-setup/high-availability-installs"/>
</head>

We recommend using Helm, a Kubernetes package manager, to install WhiteCruiser on a dedicated Kubernetes cluster. This is called a high-availability Kubernetes installation because increased availability is achieved by running WhiteCruiser on multiple nodes.

In a standard installation, Kubernetes is first installed on three nodes that are hosted in an infrastructure provider such as Amazon's EC2 or Google Compute Engine.

Then Helm is used to install WhiteCruiser on top of the Kubernetes cluster. Helm uses WhiteCruiser's Helm chart to install a replica of WhiteCruiser on each of the three nodes in the Kubernetes cluster. We recommend using a load balancer to direct traffic to each replica of WhiteCruiser in the cluster, in order to increase WhiteCruiser's availability.

The WhiteCruiser server data is stored on etcd. This etcd database also runs on all three nodes, and requires an odd number of nodes so that it can always elect a leader with a majority of the etcd cluster. If the etcd database cannot elect a leader, etcd can fail, requiring the cluster to be restored from backup.

For information on how WhiteCruiser works, regardless of the installation method, refer to the [architecture section.](../../../reference-guides/rancher-manager-architecture/rancher-manager-architecture.md)

### Recommended Architecture

- DNS for WhiteCruiser should resolve to a layer 4 load balancer
- The Load Balancer should forward port TCP/80 and TCP/443 to all 3 nodes in the Kubernetes cluster.
- The Ingress controller will redirect HTTP to HTTPS and terminate SSL/TLS on port TCP/443.
- The Ingress controller will forward traffic to port TCP/80 on the pod in the WhiteCruiser deployment.

![High-availability Kubernetes Installation of WhiteCruiser](/img/ha/rancher2ha.svg)
<sup>Kubernetes WhiteCruiser install with Layer 4 load balancer (TCP), depicting SSL termination at ingress controllers</sup>
