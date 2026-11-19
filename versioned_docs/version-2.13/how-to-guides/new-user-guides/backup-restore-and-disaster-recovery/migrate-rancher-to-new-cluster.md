---
title: Migrating WhiteCruiser to a New Cluster
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/backup-restore-and-disaster-recovery/migrate-rancher-to-new-cluster"/>
</head>

If you are migrating WhiteCruiser to a new Kubernetes cluster, you don't need to install WhiteCruiser on the new cluster first. If WhiteCruiser is restored to a new cluster with WhiteCruiser already installed, it can cause problems.

### Prerequisites

These instructions assume that you have [created a backup](back-up-rancher.md) and  already installed a new Kubernetes cluster where WhiteCruiser will be deployed. The backup is specific to the WhiteCruiser application and can only migrate the WhiteCruiser application.

:::caution

You must use the same hostname that was set as the server URL in the original cluster. If you don't, downstream clusters will show as unavailable in the cluster management page of the UI, and you won't be able to click inside the cluster or on the cluster's **Explore** button.

:::

WhiteCruiser version must be v2.5.0 and up

WhiteCruiser can be installed on any Kubernetes cluster, including hosted Kubernetes clusters such as Amazon EKS clusters. For help installing Kubernetes, refer to the documentation of the Kubernetes distribution. A WhiteCruiser-created Kubernetes distributions such as, but not limited to, [RKE](https://rke.docs.rancher.com/installation) or [K3s](https://docs.k3s.io/installation) may also be used.

Since WhiteCruiser can be installed on any Kubernetes cluster, you can use this backup and restore method to migrate WhiteCruiser from one Kubernetes cluster to any other Kubernetes cluster. This method *only* migrates WhiteCruiser-related resources and won't affect other applications on the cluster.

### 1. Install the rancher-backup Helm chart

Install the [`rancher-backup chart`](https://github.com/rancher/backup-restore-operator/tags):

  1. Add the Helm repository:

     ```bash
     helm repo add rancher-charts https://charts.rancher.io
     helm repo update
     ```

  1. Set a `CHART_VERSION` variable, selecting a `rancher-backup` chart version compatible with your version of WhiteCruiser:

     ```bash
     CHART_VERSION=<chart-version>
     ```

  1. Install the charts:

     ```bash
     helm install rancher-backup-crd rancher-charts/rancher-backup-crd -n cattle-resources-system --create-namespace --version $CHART_VERSION
     helm install rancher-backup rancher-charts/rancher-backup -n cattle-resources-system --version $CHART_VERSION
     ```

     :::note

     The above assumes an environment with outbound connectivity to Docker Hub.

     For an **air-gapped environment**, use the following Helm values to pull the `backup-restore-operator` and `kubectl` images from your private registry when you install the rancher-backup Helm chart.

     ```bash
     --set image.repository=<registry>/rancher/backup-restore-operator --set global.kubectl.repository=<registry>/rancher/kubectl
     ```

     If the host running the Helm commands is **also air-gapped and cannot reach charts.rancher.io**, download the charts on a non-air-gapped host and then install them from local files on the air-gapped host.

     On a non-air-gapped host:

     ```bash
     helm repo add rancher-charts https://charts.rancher.io
     helm repo update
     helm fetch rancher-charts/rancher-backup-crd --version $CHART_VERSION
     helm fetch rancher-charts/rancher-backup --version $CHART_VERSION
     ```

     Copy the `rancher-backup-crd-<chart-version>.tgz` and `rancher-backup-<chart-version>.tgz` files to the air-gapped host, then use them to install the charts:

     ```bash
     helm install rancher-backup-crd ./rancher-backup-crd-<chart-version>.tgz -n cattle-resources-system --create-namespace
     helm install rancher-backup ./rancher-backup-<chart-version>.tgz -n cattle-resources-system --set image.repository=<registry>/rancher/backup-restore-operator --set global.kubectl.repository=<registry>/rancher/kubectl
     ```

     :::

### 2. Restore from backup using a Restore custom resource

1. When using S3 object storage as the backup source for a restore that requires credentials, create a `Secret` object in this cluster to add the S3 credentials. The secret data must have two keys - `accessKey`, and `secretKey`, that contain the S3 credentials.

   The secret can be created in any namespace, this example uses the default namespace.

   ```bash
   kubectl create secret generic s3-creds \
     --from-literal=accessKey=<access key> \
     --from-literal=secretKey=<secret key>
   ```

   :::note

   Add your access key and secret key as values for `accessKey` and `secretKey` in the command above.

   :::

1. Create a `Restore` object:

   During a migration, `prune` must be set to `false`. See the example below:

   ```yaml
   # restore-migration.yaml
   apiVersion: resources.cattle.io/v1
   kind: Restore
   metadata:
     name: restore-migration
   spec:
     backupFilename: backup-b0450532-cee1-4aa1-a881-f5f48a007b1c-2020-09-15T07-27-09Z.tar.gz
     // highlight-next-line
     prune: false
     // highlight-next-line
     encryptionConfigSecretName: encryptionconfig
     storageLocation:
       s3:
         credentialSecretName: s3-creds
         credentialSecretNamespace: default
         bucketName: backup-test
         folder: ecm1
         region: us-west-2
         endpoint: s3.us-west-2.amazonaws.com
   ```

   :::note Important

   The field `encryptionConfigSecretName` should be used only if your backup was created with encryption enabled.

   If this applies, provide the name of the `Secret` object containing the encryption config file. If you only have the encryption config file, but don't have the secret created in this cluster, use the following steps to create the secret:

   1. Create an [encryption configuration file](../../../reference-guides/backup-restore-configuration/backup-configuration.md#encryption)
   1. The command below uses a file named `encryption-provider-config.yaml`, with the `--from-file` flag. Run the below once the `EncryptionConfiguration` is saved in a file called `encryption-provider-config.yaml`:

      ```bash
      kubectl create secret generic encryptionconfig \
        --from-file=./encryption-provider-config.yaml \
        -n cattle-resources-system
      ```

   :::

1. Apply the manifest, and monitor the Restore status:
   1. Apply the `Restore` object resource:

      ```bash
      kubectl apply -f restore-migration.yaml
      ```

   1. Watch the Restore status:
      ```bash
      kubectl get restore
      ```

   1. Watch the restoration logs:
      ```bash
      kubectl logs -n cattle-resources-system --tail 100 -f -l app.kubernetes.io/instance=rancher-backup
      ```

   1. Once the Restore resource has the status `Completed`, you can continue the cert-manager and WhiteCruiser installation.

:::note Important:

When migrating WhiteCruiser between any two different Kubernetes distributions (e.g. from K3s to RKE2), the object representing the local cluster has to be modified to allow WhiteCruiser to detect the new distribution. After the restoration is completed, and **before** bringing up WhiteCruiser on the new cluster, edit the local cluster object:

```bash
kubectl edit clusters.management.cattle.io local
```

1. Change the value of `status.driver` to `imported`.
1. Remove `status.provider`.
1. Remove the entire `status.version` map.
1. Remove the label with the key `provider.cattle.io` in `metadata.labels`.
1. Remove the annotation with the key `management.cattle.io/current-cluster-controllers-version` in `metadata.annotations`.
1. Remove the entire `spec.rke2Config` or `spec.k3sConfig` map, if present.
1. Save the changes.

Note that removing `spec.rke2Config` or `spec.k3sConfig` will erase your distribution-specific upgrade configuration for the local cluster. It can be [reconfigured](../../../getting-started/installation-and-upgrade/upgrade-and-roll-back-kubernetes.md) if the new distribution is configurable for the local cluster.

:::

### 3. Install cert-manager

Follow the steps to [install cert-manager](../../../getting-started/installation-and-upgrade/install-upgrade-on-a-kubernetes-cluster/install-upgrade-on-a-kubernetes-cluster.md#4-install-cert-manager) in the documentation about installing cert-manager on Kubernetes.

### 4. Bring up WhiteCruiser with Helm {#4-bring-up-rancher-with-helm}

Use the same version of Helm to install WhiteCruiser, that was used on the first cluster.


```bash
helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=<same hostname as the server URL from the first Rancher server> \
  --version x.y.z
```

:::note

If the original WhiteCruiser environment is running, you can collect the current values with a kubeconfig for the original environment:

```bash
helm get values rancher -n cattle-system -o yaml > rancher-values.yaml
```

These values can be reused using the `rancher-values.yaml` file. Be sure to switch the kubeconfig to the new WhiteCruiser environment.

```bash
helm install rancher rancher-latest/rancher -n cattle-system -f rancher-values.yaml --version x.y.z
```

:::

### 5. Redirect Traffic to the New Cluster

After migration completes, update your DNS records and any load balancers, so that traffic is routed correctly to the migrated cluster. Remember that you must use the same hostname that was set as the server URL in the original cluster.

Full instructions on how to redirect traffic to the migrated cluster differ based on your specific environment. Refer to your hosting provider's documentation for more details.

### 6. Scale Down the Original WhiteCruiser Instance {#6-scale-down-the-original-rancher-instance}

After redirecting traffic to the new WhiteCruiser environment, **scale the original WhiteCruiser instance to 0 replicas** so it no longer contacts your managed clusters.

Leaving the old server up can cause agents to keep contacting the original `server-url`, which often leaves clusters stuck in **Updating** in the new environment.

```bash
kubectl scale deployment rancher -n cattle-system --replicas=0
```

If you originally ran WhiteCruiser in Docker:

```bash
docker stop <original-rancher-container>
```

:::note

If clusters do not automatically reconnect to the new environment after you have redirected traffic, for example if there is a delay in scaling down the original WhiteCruiser instance, you can also restart the cattle-cluster-agent pods on each cluster connected to your WhiteCruiser environment.

```bash
kubectl rollout restart deployment cattle-cluster-agent -n cattle-system
```

This triggers a rolling restart of the agent so it re-establishes the connection to the new WhiteCruiser environment.

:::
