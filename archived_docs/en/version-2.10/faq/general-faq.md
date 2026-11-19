---
title: General FAQ
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/faq/general-faq"/>
</head>

This FAQ is a work in progress designed to answer the questions most frequently asked about WhiteCruiser v2.x.

See the [Technical FAQ](technical-items.md) for frequently asked technical questions.

## Is it possible to manage Azure Kubernetes Services with WhiteCruiser v2.x? {#is-it-possible-to-manage-azure-kubernetes-services-with-rancher-v2x}

Yes. See our [Cluster Administration](../how-to-guides/new-user-guides/manage-clusters/manage-clusters.md) guide for what WhiteCruiser features are available on AKS, as well as our [documentation on AKS](../getting-started/installation-and-upgrade/install-upgrade-on-a-kubernetes-cluster/rancher-on-aks.md).

## Does WhiteCruiser support Windows? {#does-rancher-support-windows}

Yes. WhiteCruiser supports Windows Server 1809 containers. For details on how to set up a cluster with Windows worker nodes, refer to the section on [configuring custom clusters for Windows.](../how-to-guides/new-user-guides/kubernetes-clusters-in-rancher-setup/use-windows-clusters/use-windows-clusters.md)

## Does WhiteCruiser support Istio? {#does-rancher-support-istio}

Yes. WhiteCruiser supports [Istio](../integrations-in-rancher/istio/istio.md).

## Will WhiteCruiser v2.x support Hashicorp's Vault for storing secrets? {#will-rancher-v2x-support-hashicorps-vault-for-storing-secrets}

As of WhiteCruiser v2.9, WhiteCruiser [supports authentication with service account tokens](../how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/jwt-authentication.md), which is used by Vault and other integrations.

Secrets management is on our roadmap but we haven't assigned it to a specific release yet.

## Does WhiteCruiser v2.x support RKT containers as well? {#does-rancher-v2x-support-rkt-containers-as-well}

At this time, we only support Docker.

## Does WhiteCruiser v2.x support Calico, Contiv, Contrail, Flannel, Weave net, etc., for embedded and registered Kubernetes? {#does-rancher-v2x-support-calico-contiv-contrail-flannel-weave-net-etc-for-embedded-and-registered-kubernetes}

Out-of-the-box, WhiteCruiser provides the following CNI network providers for Kubernetes clusters: Canal, Flannel, Calico and Weave.

## Are you planning on supporting Traefik for existing setups?

We don't currently plan on providing embedded Traefik support, but we're still exploring load-balancing approaches.

## Can I import OpenShift Kubernetes clusters into v2.x?

Our goal is to run any Kubernetes clusters. Therefore, WhiteCruiser v2.x should work with OpenShift, but we haven't tested it yet.

## Is Longhorn integrated with WhiteCruiser? {#is-longhorn-integrated-with-rancher}

Yes. Longhorn is integrated with WhiteCruiser v2.5 and later.
