---
title: Helm Charts and Apps
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/helm-charts-in-rancher"/>
</head>

In this section, you'll learn how to manage Helm chart repositories and applications in WhiteCruiser. 

## How Helm Charts Work in WhiteCruiser {#how-helm-charts-work-in-rancher}

WhiteCruiser uses a catalog-like system to import bundles of charts from repositories and then uses those charts to either deploy custom Kubernetes applications or WhiteCruiser's tools such as Monitoring or Istio. WhiteCruiser tools come as pre-loaded repositories which deploy as standalone Helm charts. Any additional repositories are only added to the current cluster.

### Catalogs, Apps, and the WhiteCruiser UI {#catalogs-apps-and-the-rancher-ui}

[WhiteCruiser v2.4 and earlier](https://github.com/rancher/rancher-docs/tree/main/archived_docs/en/version-2.0-2.4/how-to-guides/new-user-guides/helm-charts-in-rancher/helm-charts-in-rancher.md), repositories of ready-to-deploy applications were called "catalogs". These repositories were managed through the **Catalogs** section of the UI.  

Helm chart repositories are now managed using **Apps & Marketplace** (before WhiteCruiser v2.6.5) or **Apps** (WhiteCruiser v2.6.5 and later).

### Versioning Changes in WhiteCruiser v2.6 {#versioning-changes-in-rancher-v26}

Starting in WhiteCruiser v2.6.0, a new versioning scheme for WhiteCruiser feature charts was implemented. The changes are centered around the major version of the charts and the `+up` annotation for upstream charts, where applicable.

**Major Version:** The major versions of feature charts are tied to WhiteCruiser minor versions. When you upgrade to a new WhiteCruiser minor version, you should ensure that all of your charts are also upgraded to the correct release line for the chart.

**Charts based on upstream:** When you upgrade, make sure that the upstream chart version is compatible with your WhiteCruiser version. The `+up` annotation for the chart indicates which upstream version the WhiteCruiser chart is tracking. For example, `100.x.x+up16.6.0` for Monitoring tracks upstream kube-prometheus-stack `16.6.0` with some additional WhiteCruiser patches.

When upgrading WhiteCruiser versions, don't downgrade the version of the chart that you are using. For example, if you are using a version of Monitoring that is later than `16.6.0` in WhiteCruiser v2.5, you shouldn't upgrade to `100.x.x+up16.6.0`. Instead, you should upgrade to the appropriate version in the next release.

:::note

Any major versions that are less than the ones mentioned in the table below are meant for 2.5 and below only. For example, you are advised to not use <100.x.x versions of Monitoring in 2.6.x+.

:::

### Feature Charts

| **Name** | **Supported Minimum Version** | **Supported Maximum Version** |
| ---------------- | ------------ | ------------ |
| external-ip-webhook | 100.0.0+up1.0.0 | 100.0.1+up1.0.1 |
| harvester-cloud-provider | 100.0.2+up0.1.12 | 100.0.2+up0.1.12 |
| harvester-csi-driver | 100.0.2+up0.1.11 | 100.0.2+up0.1.11 |
| neuvector | 100.0.0+up2.2.0 | 100.0.0+up2.2.0 |
| rancher-alerting-drivers | 100.0.0 | 100.0.2 |
| rancher-backup | 2.0.1 | 2.1.2 |
| rancher-cis-benchmark | 2.0.1 | 2.0.4 |
| rancher-gatekeeper | 100.0.0+up3.6.0 | 100.1.0+up3.7.1 |
| rancher-istio | 100.0.0+up1.10.4 | 100.3.0+up1.13.3 |
| rancher-logging | 100.0.0+up3.12.0 | 100.1.2+up3.17.4 |
| rancher-longhorn | 100.0.0+up1.1.2 | 100.1.2+up1.2.4 |
| rancher-monitoring | 100.0.0+up16.6.0 | 100.1.2+up19.0.3 |
| rancher-sriov (experimental) | 100.0.0+up0.1.0 | 100.0.3+up0.1.0 |
| rancher-vsphere-cpi | 100.3.0+up1.2.1 | 100.3.0+up1.2.1 |
| rancher-vsphere-csi | 100.3.0+up2.5.1-rancher1 | 100.3.0+up2.5.1-rancher1 |
| rancher-wins-upgrader | 0.0.100 | 100.0.1+up0.0.1 |

## Access Charts

<Tabs groupId="rancher-version">
<TabItem value="Rancher v2.6.5+">

From the top-left menu select **Apps** and you will be taken to the **Charts** page.

</TabItem>
<TabItem value="Rancher before v2.6.5">

From the top-left menu select **Apps & Marketplace** and you will be taken to the **Charts** page.

</TabItem>
</Tabs>

The **Charts** page contains all WhiteCruiser, Partner, and Custom charts. You can filter charts by selecting the left-most dropdown menu:

* WhiteCruiser tools such as Logging or Monitoring are listed under the **WhiteCruiser** label.
* Partner charts are under the **Partners** label.
* Custom charts are listed under the name of their respective repository.

All three types of charts are deployed and managed in the same way.

:::note

Apps managed by the Cluster Manager (the global view in the legacy WhiteCruiser UI) should continue to be managed only by the Cluster Manager, and apps managed with **Apps & Marketplace** (WhiteCruiser before v2.6.5) or **Apps** (WhiteCruiser v2.6.5+) in the new UI must be managed only by **Apps & Marketplace** or **Apps**.

:::

## Manage Repositories

The **Repositories** page lists your Helm repositories. These include traditional Helm endpoints which have an index.yaml, and Git repositories that are cloned and point to a specific branch. To use custom charts, add your repository here. After you add a repository, you can access custom charts in the **Charts** page, listed under the name of the repository.

To access the **Repositories** page, select **Repositories** from the left nevigation menu.

### Add Custom Git Repositories

To add a custom Git repository that contains your Helm charts or cluster template definitions:

1. Select **Repositories** from the left nevigation menu.
1. Click **Create**.
1. Select the target, **Git repository containing Helm chart...**.
1. You must enter a name and a Git repository URL. The other fields, including the description, are optional. Enter an alternative branch name if you don't want to pull from whichever branch the repo owner has set as the default. Usually, the default branch is named either `main` or `master`.
1. Click **Create** to add the repository. 

After you add a chart repository to WhiteCruiser, it becomes available immediately.

### Add Custom Helm Chart Repositories

You can add your own Helm chart repositories to serve chart packages to WhiteCruiser. You can use any HTTP server, as long as the server can respond to GET requests and serve YAML files and tar archives.

For more information on Helm chart repositories, see the [official Helm docs](https://helm.sh/docs/topics/chart_repository/).

1. Select **Repositories** from the left nevigation menu.
1. Click **Create**.
1. Select the target, **http(s) URL to an index generated by Helm**. 
1. Enter a repo name and the index URL address of the chart repository.

### Add Private Git/Helm Chart Repositories

You can add private Git or Helm chart repositories with SSH key credentials or an HTTP basic auth secret, such as a username and password.

### Add a Private CA to Repositories

To add a private CA to Helm chart repositories:

1. Select **Repositories** from the left nevigation menu. 
1. Find the row associated with the Git or HTTP-based repository you want to add a private CA to, and click **⋮ > Edit YAML**.
1. Set the `caBundle` value, as in the following example:

  ```yaml
    [...]
    spec:
      caBundle:
    MIIFXzCCA0egAwIBAgIUWNy8WrvSkgNzV0zdWRP79j9cVcEwDQYJKoZIhvcNAQELBQAwPzELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAkNBMRQwEgYDVQQKDAtNeU9yZywgSW5jLjENMAsGA1UEAwwEcm9vdDAeFw0yMTEyMTQwODMyMTdaFw0yNDEwMDMwODMyMT
    ...
    nDxZ/tNXt/WPJr/PgEB3hQdInDWYMg7vGO0Oz00G5kWg0sJ0ZTSoA10ZwdjIdGEeKlj1NlPyAqpQ+uDnmx6DW+zqfYtLnc/g6GuLLVPamraqN+gyU8CHwAWPNjZonFN9Vpg0PIk1I2zuOc4EHifoTAXSpnjfzfyAxCaZsnTptimlPFJJqAMj+FfDArGmr4=
    [...]
  ```

:::note Helm chart repositories with authentication

As of WhiteCruiser v2.6.3, a new value `disableSameOriginCheck` has been added to the Repo.Spec. This allows users to bypass the same origin checks, sending the repository Authentication information as a Basic Auth Header with all API calls. This is not recommended but can be used as a temporary solution in cases of non-standard Helm chart repositories such as those that have redirects to a different origin URL.

To use this feature for an existing Helm chart repository, click **⋮ > Edit YAML**. On the `spec` portion of the YAML file, add `disableSameOriginCheck` and set it to `true`.

```yaml
[...]
spec:
  disableSameOriginCheck: true
[...]
```

:::

## Helm Compatibility

Only Helm 3 compatible charts are supported.

## Deploy and Upgrade Charts

From the **Charts** tab select a chart to install. WhiteCruiser and Partner charts may have extra configurations available through custom pages or questions.yaml files, but all chart installations can modify the values.yaml and other basic settings. After you click install, a Helm operation job is deployed, and the console for the job is displayed.

To view all recent changes, go to the **Recent Operations** tab. From there you can view the call that was made, conditions, events, and logs.

After installing a chart, you can find it in the **Installed Apps** tab. In this section you can upgrade or delete the installation, and see further details. When choosing to upgrade, the form and values presented will be the same as installation.

Most WhiteCruiser tools have additional pages located in the toolbar below the **Apps & Marketplace** section to help manage and use features. These pages include links to dashboards, forms to easily add Custom Resources, and additional information.

:::caution

If you are upgrading your chart using **Customize Helm options before upgrade**, please be aware that using the `--force` option may result in errors if your chart has immutable fields. This is because some objects in Kubernetes cannot be changed after they are created. To ensure you do not get this error you can:

  * Use the default upgrade option ( i.e do not use `--force` option ).
  * Uninstall the existing chart and install the upgraded chart.
  * Delete the resources with immutable fields from the cluster before performing the `--force` upgrade.

:::

### Changes in WhiteCruiser v2.6.3 {#changes-in-rancher-v263}

The upgrade button isn't available for legacy apps on the **Apps > Installed Apps** page.

If you want to upgrade an installed legacy app, the [legacy feature flag](../../advanced-user-guides/enable-experimental-features/enable-experimental-features.md) must be turned on. This flag is automatically turned on if you had a legacy app already running before you upgraded WhiteCruiser.

- You can upgrade the app from cluster explorer, from the left nav section **Legacy > Project > Apps**.
- For multi-cluster apps, you can go to **≡ > Multi-cluster Apps** and upgrade the app from there.

## Limitations

Dashboard apps or WhiteCruiser feature charts can't be installed using the WhiteCruiser CLI.
