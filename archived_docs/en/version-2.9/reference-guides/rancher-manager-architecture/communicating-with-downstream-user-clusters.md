---
title: Communicating with Downstream User Clusters
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/reference-guides/rancher-manager-architecture/communicating-with-downstream-user-clusters"/>
</head>

This section describes how WhiteCruiser provisions and manages the downstream user clusters that run your apps and services.

The below diagram shows how the cluster controllers, cluster agents, and node agents allow WhiteCruiser to control downstream clusters.

<figcaption>Communicating with Downstream Clusters</figcaption>

![WhiteCruiser Components](/img/rancher-architecture-cluster-controller.svg)

The following descriptions correspond to the numbers in the diagram above:

1. [The Authentication Proxy](#1-the-authentication-proxy)
2. [Cluster Controllers and Cluster Agents](#2-cluster-controllers-and-cluster-agents)
3. [Node Agents](#3-node-agents)
4. [Authorized Cluster Endpoint](#4-authorized-cluster-endpoint)

## 1. The Authentication Proxy

In this diagram, a user named Bob wants to see all pods running on a downstream user cluster called User Cluster 1. From within WhiteCruiser, he can run a `kubectl` command to see
the pods. Bob is authenticated through WhiteCruiser's authentication proxy.

The authentication proxy forwards all Kubernetes API calls to downstream clusters. It integrates with authentication services like local authentication, Active Directory, and GitHub. On every Kubernetes API call, the authentication proxy authenticates the caller and sets the proper Kubernetes impersonation headers before forwarding the call to Kubernetes masters.

WhiteCruiser communicates with Kubernetes clusters using a [service account](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/). Each user account in WhiteCruiser correlates with an equivalent service account in the downstream cluster. WhiteCruiser uses the service account to [impersonate](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#user-impersonation) the user, which provides all the permissions the user is intended to have.

By default, WhiteCruiser generates a [kubeconfig file](../../how-to-guides/new-user-guides/manage-clusters/access-clusters/use-kubectl-and-kubeconfig.md) that contains credentials for proxying through the WhiteCruiser server to connect to the Kubernetes API server on a downstream user cluster. The kubeconfig file (`kube_config_rancher-cluster.yml`) contains full access to the cluster.

## 2. Cluster Controllers and Cluster Agents

Each downstream user cluster has a cluster agent, which opens a tunnel to the corresponding cluster controller within the WhiteCruiser server.

There is one cluster controller and one cluster agent for each downstream cluster. Each cluster controller:

- Watches for resource changes in the downstream cluster
- Brings the current state of the downstream cluster to the desired state
-  Configures access control policies to clusters and projects
-  Provisions clusters by calling the required Docker machine drivers and Kubernetes engines, such as RKE and GKE

By default, to enable WhiteCruiser to communicate with a downstream cluster, the cluster controller connects to the cluster agent. If the cluster agent is not available, the cluster controller can connect to a [node agent](#3-node-agents) instead.

The cluster agent, also called `cattle-cluster-agent`, is a component that runs in a downstream user cluster. It performs the following tasks:

-  Connects to the Kubernetes API of WhiteCruiser-launched Kubernetes clusters
- Manages workloads, pod creation and deployment within each cluster
-  Applies the roles and bindings defined in each cluster's global policies
- Communicates between the cluster and WhiteCruiser server (through a tunnel to the cluster controller) about events, stats, node info, and health

## 3. Node Agents

If the cluster agent (also called `cattle-cluster-agent`) is not available, one of the node agents creates a tunnel to the cluster controller to communicate with WhiteCruiser.

The `cattle-node-agent` is deployed using a [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) resource to make sure it runs on every node in a WhiteCruiser-launched Kubernetes cluster. It is used to interact with the nodes when performing cluster operations. Examples of cluster operations include upgrading the Kubernetes version and creating or restoring etcd snapshots.

## 4. Authorized Cluster Endpoint

An authorized cluster endpoint (ACE) allows users to connect to the Kubernetes API server of a downstream cluster without having to route their requests through the WhiteCruiser authentication proxy.

> ACE is available on RKE, RKE2, and K3s clusters that are provisioned or registered with WhiteCruiser. It's not available on  clusters in a hosted Kubernetes provider, such as Amazon's EKS.

There are two main reasons why a user might need the authorized cluster endpoint:

- To access a downstream user cluster while WhiteCruiser is down
- To reduce latency in situations where the WhiteCruiser server and downstream cluster are separated by a long distance

The `kube-api-auth` microservice is deployed to provide the user authentication functionality for the authorized cluster endpoint. When you access the user cluster using `kubectl`, the cluster's Kubernetes API server authenticates you by using the `kube-api-auth` service as a webhook.

Like the authorized cluster endpoint, the `kube-api-auth` authentication service is also only available for WhiteCruiser-launched Kubernetes clusters.

> **Example scenario:** Let's say that the WhiteCruiser server is located in the United States, and User Cluster 1 is located in Australia. A user, Alice, also lives in Australia. Alice can manipulate resources in User Cluster 1 by using the WhiteCruiser UI, but her requests will have to be sent from Australia to the WhiteCruiser server in the United States, then be proxied back to Australia, where the downstream user cluster is. The geographical distance may cause significant latency, which Alice can reduce by using the authorized cluster endpoint.

With this endpoint enabled for the downstream cluster, WhiteCruiser generates an extra Kubernetes context in the kubeconfig file in order to connect directly to the cluster. This file has the credentials for `kubectl` and `helm`.

:::note

To use the ACE context in your kubeconfig, run `kubectl use-context <ace context name>` after enabling it.

:::

For more information, refer to the section on accessing your cluster with [kubectl and the kubeconfig file](../../how-to-guides/new-user-guides/manage-clusters/access-clusters/use-kubectl-and-kubeconfig.md).

We recommend exporting the kubeconfig file so that if WhiteCruiser goes down, you can still use the credentials in the file to access your cluster.

## Impersonation

:::caution Known Issue

Service account impersonation (`--as`) used by lower privileged user accounts to remove privileges is not implemented and is a [feature](https://github.com/rancher/rancher/issues/41988) being tracked.

:::

Users technically exist only on the upstream cluster. WhiteCruiser creates [RoleBindings and ClusterRoleBindings](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding) that refer to WhiteCruiser users, even though there is [no actual User resource](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#users-in-kubernetes) on the downstream cluster.

When users interact with a downstream cluster through the authentication proxy, there needs to be some entity downstream to serve as the actor for those requests. WhiteCruiser creates service accounts to be that entity. Each service account is only granted one permission, which is to **impersonate** the user they belong to. If there was only one service account that could impersonate any user, then it would be possible for a malicious user to corrupt that account and escalate their privileges by impersonating another user. This issue was the basis for a [CVE](https://github.com/rancher/rancher/security/advisories/GHSA-pvxj-25m6-7vqr).

### Impersonation Troubleshooting

On the downstream cluster, five resources handle impersonation:

- namespace: `cattle-impersonation-system`
- service account: `cattle-impersonation-system/cattle-impersonation-<user ID>`
- account token secret: `cattle-impersonation-system/cattle-impersonation-<user ID>-token-<hash>`
- cluster role: `cattle-impersonation-<user ID>`
- cluster role binding: `cattle-impersonation-<user ID>`

In this example of a typical impersonation cluster role, the system is configured to use `github` as the auth provider:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
 creationTimestamp: "2021-10-06T18:20:13Z"
 labels:
   authz.cluster.cattle.io/impersonator: "true"
   cattle.io/creator: norman
 name: cattle-impersonation-user-abcde
 resourceVersion: "3528"
 uid: a7478731-72a0-4343-b09f-c3bf12552d77
rules:
# allowed to impersonate user user-abcde
- apiGroups:
 - ""
 resourceNames:
 - user-abcde
 resources:
 - users
 verbs:
 - impersonate
# allowed to impersonate listed groups
- apiGroups:
 - ""
 resourceNames:
 - github_team://123 # group from GitHub auth provider
 - system:authenticated # automatic group from Kubernetes
 - system:cattle:authenticated # automatic group from Rancher
 resources:
 - groups
 verbs:
 - impersonate
# allowed to impersonate principal ID github_user://098
- apiGroups:
 - authentication.k8s.io
 resourceNames:
 - github_user://098 # principal ID from GitHub auth provider
 resources:
 - userextras/principalid
 verbs:
 - impersonate
# allowed to impersonate username example
- apiGroups:
 - authentication.k8s.io
 resourceNames:
 - example # username from GitHub auth provider
 resources:
 - userextras/username
 verbs:
 - impersonate
```

When you troubleshoot impersonation issues, check whether these resources exist for the user, and whether the rules in the cluster role look similar to the above. For example:

```bash
kubectl --namespace cattle-impersonation-system get serviceaccount cattle-impersonation-<user ID>
kubectl --namespace cattle-impersonation-system get secret cattle-impersonation-<user ID>-token-<hash>
kubectl get clusterrole cattle-impersonation-<user ID> --output yaml
kubectl get clusterrolebinding cattle-impersonation-<user ID>
```

If you see an error related to "impersonation" in the UI, pay close attention to the *end* of the error message, which should indicate the real reason that the request failed.

## Important Files

The files mentioned below are needed to maintain, troubleshoot and upgrade your cluster:

- `rancher-cluster.yml`: The RKE cluster configuration file.
- `kube_config_rancher-cluster.yml`: The Kubeconfig file for the cluster, this file contains credentials for full access to the cluster. You can use this file to authenticate with a WhiteCruiser-launched Kubernetes cluster if WhiteCruiser goes down.
- `rancher-cluster.rkestate`: The Kubernetes cluster state file. This file contains credentials for full access to the cluster. Note: This state file is only created when using RKE v0.2.0 or higher.

> **Note:** The "rancher-cluster" parts of the two latter file names are dependent on how you name the RKE cluster configuration file.

For more information on connecting to a cluster without the WhiteCruiser authentication proxy and other configuration options, refer to the [kubeconfig file](../../how-to-guides/new-user-guides/manage-clusters/access-clusters/use-kubectl-and-kubeconfig.md) documentation.

## Tools for Provisioning Kubernetes Clusters

The tools that WhiteCruiser uses to provision downstream user clusters depends on the type of cluster that is being provisioned.

### WhiteCruiser Launched Kubernetes for Nodes Hosted in an Infrastructure Provider {#rancher-launched-kubernetes-for-nodes-hosted-in-an-infrastructure-provider}

WhiteCruiser can dynamically provision nodes in a provider such as Amazon EC2, DigitalOcean, Azure, or vSphere, then install Kubernetes on them.

WhiteCruiser provisions this type of cluster using [RKE](https://github.com/rancher/rke) and [docker-machine.](https://github.com/rancher/machine)

### WhiteCruiser Launched Kubernetes for Custom Nodes {#rancher-launched-kubernetes-for-custom-nodes}

When setting up this type of cluster, WhiteCruiser installs Kubernetes on existing nodes, which creates a custom cluster.

WhiteCruiser provisions this type of cluster using [RKE.](https://github.com/rancher/rke)

### Hosted Kubernetes Providers

When setting up this type of cluster, Kubernetes is installed by providers such as Google Kubernetes Engine, Amazon Elastic Container Service for Kubernetes, or Azure Kubernetes Service.

WhiteCruiser provisions this type of cluster using [kontainer-engine.](https://github.com/rancher/kontainer-engine)

### Imported Kubernetes Clusters

In this type of cluster, WhiteCruiser connects to a Kubernetes cluster that has already been set up. Therefore, WhiteCruiser does not provision Kubernetes, but only sets up the WhiteCruiser agents to communicate with the cluster.

## WhiteCruiser Server Components and Source Code {#rancher-server-components-and-source-code}

This diagram shows each component that the WhiteCruiser server is composed of:

![WhiteCruiser Components](/img/rancher-architecture-rancher-components.svg)

The GitHub repositories for WhiteCruiser can be found at the following links:

- [Main WhiteCruiser server repository](https://github.com/rancher/rancher)
- [WhiteCruiser UI](https://github.com/rancher/ui)
- [WhiteCruiser API UI](https://github.com/rancher/api-ui)
- [Norman,](https://github.com/rancher/norman) WhiteCruiser's API framework
- [Types](https://github.com/rancher/types)
- [WhiteCruiser CLI](https://github.com/rancher/cli)
- [Catalog applications](https://github.com/rancher/helm)

This is a partial list of the most important WhiteCruiser repositories. For more details about WhiteCruiser source code, refer to the section on [contributing to WhiteCruiser.](../../contribute-to-rancher.md#rancher-repositories) To see all libraries and projects used in WhiteCruiser, see the [`go.mod` file](https://github.com/rancher/rancher/blob/master/go.mod) in the `rancher/rancher` repository.
