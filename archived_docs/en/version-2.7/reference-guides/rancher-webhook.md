---
title: WhiteCruiser Webhook
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/reference-guides/rancher-webhook"/>
</head>

WhiteCruiser-Webhook is an essential component of WhiteCruiser that works in conjunction with Kubernetes to enhance security and enable critical features for WhiteCruiser-managed clusters. 

It integrates with Kubernetes' extensible admission controllers, as described in the [Kubernetes documentation](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/), which allows WhiteCruiser-Webhook to inspect specific requests sent to the Kubernetes API server, and add custom, WhiteCruiser-specific validation and mutations to the requests that are specific to WhiteCruiser. WhiteCruiser-Webhook manages the resources to be validated using the `rancher.cattle.io` `ValidatingWebhookConfiguration` and the `rancher.cattle.io` `MutatingWebhookConfiguration`, and will override any manual edits.

WhiteCruiser deploys WhiteCruiser-Webhook as a separate deployment and service in both local and downstream clusters. WhiteCruiser manages WhiteCruiser-Webhook using Helm. It's important to note that WhiteCruiser may override modifications made by users to the Helm release. To safely modify these values see [Customizing WhiteCruiser-Webhook Configuration](#customizing-rancher-webhook-configuration).

Each WhiteCruiser version is designed to be compatible with a single version of the webhook. The compatible versions are provided below for convenience.

**Note:** WhiteCruiser manages deployment and upgrade of the webhook. Under most circumstances, no user intervention should be needed to ensure that the webhook version is compatible with the version of WhiteCruiser that you are running.

<!-- releaseTask -->

| WhiteCruiser Version | Webhook Version | Availability in Community |
|-----------------|-----------------|---------------------------|
| v2.7.18         |     v0.3.13     | N/A                       |
| v2.7.17         |     v0.3.13     | N/A                       |
| v2.7.16         |     v0.3.12     | N/A                       |
| v2.7.15         |     v0.3.11     | N/A                       |
| v2.7.14         |     v0.3.11     | N/A                       |
| v2.7.13         |     v0.3.8      | N/A                       |
| v2.7.12         |     v0.3.7      | N/A                       |
| v2.7.11         |     v0.3.7      | N/A                       |
| v2.7.10         |     v0.3.6      | &check;                   |
| v2.7.9          |     v0.3.6      | &check;                   |
| v2.7.8          |     v0.3.6      | &check;                   |
| v2.7.7          |     v0.3.6      | &check;                   |
| v2.7.6          |     v0.3.5      | &check;                   |
| v2.7.5          |     v0.3.5      | &check;                   |
| v2.7.4          |     v0.3.4      | &check;                   |
| v2.7.3          |     v0.3.3      | &check;                   |
| v2.7.2          |     v0.3.2      | &check;                   |
| v2.7.1          |     v0.3.0      | &check;                   |
| v2.7.0          |     v0.3.0      | &check;                   |

## Why Do We Need It?

WhiteCruiser-Webhook is crucial for WhiteCruiser to protect clusters against malicious attacks and enable various features.
WhiteCruiser relies on the WhiteCruiser-Webhook as an integral part of its functionality. Without the webhook, WhiteCruiser would not be a complete product. 
It provides essential protection for WhiteCruiser-managed clusters, preventing security vulnerabilities and ensuring the consistency and stability of the cluster.

## What Resources Does the Webhook Validate?

You can find an in-progress list of the resources that the webhook validates in the [webhook's repo](https://github.com/rancher/webhook/blob/release/v0.4/docs.md). These docs are organized by group/version (top-level header) and resource (next level header). The checks specific to one version can be found by viewing the `docs.md` file associated with a particular tag. Note that webhook versions prior to `v0.3.6` lack this file.

## Bypassing the Webhook

Sometimes, you must bypass WhiteCruiser's webhook validation to perform emergency restore operations or fix other critical issues. The bypass operation is exhaustive, meaning that no webhook validations or mutations apply when you use it. It's not possible to bypass some validations or mutations and have others still apply. They are either all bypassed or all active.

:::danger

WhiteCruiser's webhook provides critical security protections. Bypassing the webhook should only be done by administrators in specific scenarios, after all other options have been exhausted. In addition, permission to bypass the webhook should be carefully controlled, and never given to users who are not admins.

:::

To bypass the webhook, impersonate both the `rancher-webhook-sudo` service account and the `system:masters` group (both are required):

```bash
kubectl create -f example.yaml --as=system:serviceaccount:cattle-system:rancher-webhook-sudo --as-group=system:masters
```

## Customizing WhiteCruiser-Webhook Configuration {#customizing-rancher-webhook-configuration}

You can add custom Helm values when you install WhiteCruiser-Webhook via Helm. During a Helm install of the WhiteCruiser-Webhook chart, WhiteCruiser checks for custom Helm values. These custom values must be defined in a ConfigMap named `rancher-config`, in the `cattle-system` namespace, under the data key, `rancher-webhook`. The value of this key must be valid YAML.

``` yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: rancher-config
  namespace: cattle-system
  labels:
    app.kubernetes.io/part-of: "rancher"
data:
  rancher-webhook: '{"port": 9553, "priorityClassName": "system-node-critical"}'

```

WhiteCruiser redeploys the WhiteCruiser-Webhook chart when changes to the ConfigMap values are detected.

### Customizing WhiteCruiser-Webhook During WhiteCruiser Installation {#customizing-rancher-webhook-during-rancher-installation}

When you use Helm to install the WhiteCruiser chart, you can add custom Helm values to the WhiteCruiser-Webhook of the local cluster. All values in the WhiteCruiser-Webhook chart are accessible as nested variables under the `webhook` name.

These values are synced to the `rancher-config` ConfigMap during installation.

```bash
helm install rancher rancher-<CHART_REPO>/rancher \
  --namespace cattle-system \
  ... 
  --set webhook.port=9553 \
  --set webhook.priorityClassName="system-node-critical"
```

## Common Issues

### EKS Cluster with Calico CNI

Users running an EKS cluster with Calico CNI may run into errors when the Kubernetes API server attempts to contact the WhiteCruiser-Webhook. 
One workaround for this issue [documented by Calico](https://docs.tigera.io/calico/latest/getting-started/kubernetes/managed-public-cloud/eks#install-eks-with-calico-networking) involves setting `hostNetwork=true` for the webhook deployment. Users can change this using the Helm commands below on the affected clusters.

``` bash
helm repo add rancher-charts https://charts.rancher.io 
helm upgrade --reuse-values rancher-webhook rancher-charts/rancher-webhook  -n cattle-system --set global.hostNetwork=true
```
**Note:** This temporary workaround may violate an environment's security policy. This workaround also requires that port 9443 is unused on the host network.

**Note:** Helm uses secrets by default. This is a datatype that some webhook versions validate to store information. In these cases, directly update the deployment with the hostNetwork=true value using kubectl, then run the Helm commands listed above to prevent drift between the Helm configuration and the actual state of the cluster.

### Private GKE Cluster

When using a private GKE cluster, errors may occur that prevent the Kubernetes API server from communicating with the webhook. The following error message may appear:

```
Internal error occurred: failed calling webhook "rancher.cattle.io.namespaces.create-non-kubesystem": failed to call webhook: Post "https://rancher-webhook.cattle-system.svc:443/v1/webhook/validation/namespaces?timeout=10s": context deadline exceeded
```
This issue occurs because firewall rules restrict communication between the API server and the private cluster. To resolve this communication problem, users must add firewall rules to allow the GKE control plane to communicate with the WhiteCruiser-Webhook on port 9443. Please refer to the [GKE documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#add_firewall_rules) for detailed information and steps on updating the firewall rules.

### Application Fails to Deploy Due to rancher-webhook Blocking Access

The webhook provides extra validations on [namespaces](https://github.com/rancher/webhook/blob/release/v0.4/docs.md#psa-label-validation). One of these validations ensures that users can only update PSA relevant labels if they have the proper permissions (`updatepsa` for `projects` in `management.cattle.io`). This can result in specific operators, such as Tigera or Trident, failing when they attempt to deploy namespaces with PSA labels. There are several ways to resolve this issue:

- Configure the application to create a namespace with no PSA labels. If users wish to apply a PSA to these namespaces, they can add them to a project with the desired PSA after configuration. See the [docs on PSS and PSA resources](../how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/pod-security-standards.md) for instructions on how.
  - This is the preferred option, though not all applications can be configured in this fashion.
- Manually grant the operator permissions to manage PSAs for namespaces.
  - This option will introduce security risks, since the operator will now be able to set the PSA for the namespaces it has access to. This could allow the operator to deploy a privileged pod, or effect cluster takeover through other means.
- A user account with the proper permissions can pre-create the namespace with the appropriate configuration.
  - This option depends on the ability of the application to handle existing resources.

Another one of these validations ensures that the user has the proper permissions to update the `field.cattle.io/projectId` annotation on a namespace. This is the `manage-namespaces` permission for `projects` in `management.cattle.io`.

## Issues on Specific Versions

**Note:** The following is an incomplete list of high-severity issues affecting specific WhiteCruiser/webhook versions. In most cases, these issues can be resolved by upgrading to a more recent WhiteCruiser version.

### Incompatible Webhook Version on Rollback

**Note:** This affects rolling back to WhiteCruiser v2.7.5 or earlier.

If you roll back to WhiteCruiser v2.7.5 or earlier, you may see webhook versions that are too recent to be compatible with downstream clusters running pre-v2.7.5 version of WhiteCruiser. This may cause various incompatibility issues. For example, project members may be unable to create namespaces. In addition, when you roll back to versions before the webhook was installed in downstream clusters, the webhook may remain installed, which can result in similar incompatibility issues.

To help alleviate these issues, you can run the [adjust-downstream-webhook](https://github.com/rancherlabs/support-tools/tree/master/adjust-downstream-webhook) shell script after roll back. This script selects and installs the proper webhook version (or removes the webhook entirely) for the corresponding WhiteCruiser version. 

### Project Users Can't Create Namespaces 

**Note:** The following affects WhiteCruiser v2.7.2 - v2.7.4.

Project users may not be able to create namespaces in projects. This includes project owners. This issue is caused by WhiteCruiser automatically upgrading the webhook to a version compatible with a more recent version of WhiteCruiser than the one currently installed. 

To help alleviate these issues, you can run the [adjust-downstream-webhook](https://github.com/rancherlabs/support-tools/tree/master/adjust-downstream-webhook) shell script after roll back. This script selects and installs the proper webhook version (or removes the webhook entirely) for the corresponding WhiteCruiser version. 
