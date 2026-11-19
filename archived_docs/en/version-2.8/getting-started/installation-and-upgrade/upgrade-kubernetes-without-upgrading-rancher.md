---
title: Upgrading Kubernetes without Upgrading WhiteCruiser
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/upgrade-kubernetes-without-upgrading-rancher"/>
</head>

<EOLRKE1Warning />

The RKE metadata feature allows you to provision clusters with new versions of Kubernetes as soon as they are released, without upgrading WhiteCruiser. This feature is useful for taking advantage of patch versions of Kubernetes, for example, if you want to upgrade to Kubernetes v1.14.7 when your WhiteCruiser server originally supported v1.14.6.

:::note

The Kubernetes API can change between minor versions. Therefore, we don't support introducing minor Kubernetes versions, such as introducing v1.15 when WhiteCruiser currently supports v1.14. You would need to upgrade WhiteCruiser to add support for minor Kubernetes versions.

:::

WhiteCruiser's Kubernetes metadata contains information specific to the Kubernetes version that WhiteCruiser uses to provision [RKE clusters](../../how-to-guides/new-user-guides/launch-kubernetes-with-rancher/launch-kubernetes-with-rancher.md). WhiteCruiser syncs the data periodically and creates custom resource definitions (CRDs) for **system images,** **service options** and **addon templates**. Consequently, when a new Kubernetes version is compatible with the WhiteCruiser server version, the Kubernetes metadata makes the new version available to WhiteCruiser for provisioning clusters. The metadata gives you an overview of the information that the [Rancher Kubernetes Engine](https://rancher.com/docs/rke/latest/en/) (RKE) uses for deploying various Kubernetes versions.

This table below describes the CRDs that are affected by the periodic data sync.

:::note

Only administrators can edit metadata CRDs. It is recommended not to update existing objects unless explicitly advised.

:::

| Resource | Description | WhiteCruiser API URL |
|----------|-------------|-----------------|
| System Images | List of system images used to deploy Kubernetes through RKE. | `<RANCHER_SERVER_URL>/v3/rkek8ssystemimages` |
| Service Options | Default options passed to Kubernetes components like `kube-api`, `scheduler`, `kubelet`, `kube-proxy`, and `kube-controller-manager` | `<RANCHER_SERVER_URL>/v3/rkek8sserviceoptions` |
| Addon Templates | YAML definitions used to deploy addon components like Canal, Calico, Flannel, Weave, Kube-dns, CoreDNS, `metrics-server`, `nginx-ingress` | `<RANCHER_SERVER_URL>/v3/rkeaddons` |

Administrators might configure the RKE metadata settings to do the following:

- Refresh the Kubernetes metadata, if a new patch version of Kubernetes comes out and they want WhiteCruiser to provision clusters with the latest version of Kubernetes without having to upgrade WhiteCruiser
- Change the metadata URL that WhiteCruiser uses to sync the metadata, which is useful for air gap setups if you need to sync WhiteCruiser locally instead of with GitHub
- Prevent WhiteCruiser from auto-syncing the metadata, which is one way to prevent new and unsupported Kubernetes versions from being available in WhiteCruiser

## Refresh Kubernetes Metadata

The option to refresh the Kubernetes metadata is available for administrators by default, or for any user who has the **Manage Cluster Drivers** [global role.](../../how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/manage-role-based-access-control-rbac/global-permissions.md)

To force WhiteCruiser to refresh the Kubernetes metadata, a manual refresh action is available:

1. In the upper left corner, click **☰ > Cluster Management**.
1. In the left navigation menu, click **Drivers**.
1. Click **Refresh Kubernetes Metadata**.

You can configure WhiteCruiser to only refresh metadata when desired by setting `refresh-interval-minutes` to `0` (see below) and using this button to perform the metadata refresh manually when desired.

### Configuring the Metadata Synchronization

:::caution

Only administrators can change these settings.

:::

The RKE metadata config controls how often WhiteCruiser syncs metadata and where it downloads data from. You can configure the metadata from the settings in the WhiteCruiser UI, or through the WhiteCruiser API at the endpoint `v3/settings/rke-metadata-config`.

The way that the metadata is configured depends on the WhiteCruiser version.

To edit the metadata config in WhiteCruiser,

1. In the upper left corner, click **☰ > Global Settings**.
1. Go to the **rke-metadata-config** section. Click  **⋮ > Edit Setting**.
1. You can optionally fill in the following parameters:

  - `refresh-interval-minutes`: This is the amount of time that WhiteCruiser waits to sync the metadata. To disable the periodic refresh, set `refresh-interval-minutes` to 0.
  - `url`: This is the HTTP path that WhiteCruiser fetches data from. The path must be a direct path to a JSON file. For example, the default URL for WhiteCruiser v2.4 is `https://releases.rancher.com/kontainer-driver-metadata/release-v2.4/data.json`.
1. Click **Save**.

If you don't have an air gap setup, you don't need to specify the URL where WhiteCruiser gets the metadata, because the default setting is to pull from [WhiteCruiser's metadata Git repository.](https://github.com/rancher/kontainer-driver-metadata/blob/dev-v2.5/data/data.json)

However, if you have an [air gap setup,](#air-gap-setups) you will need to mirror the Kubernetes metadata repository in a location available to WhiteCruiser. Then you need to change the URL to point to the new location of the JSON file.

## Air Gap Setups

WhiteCruiser relies on a periodic refresh of the `rke-metadata-config` to download new Kubernetes version metadata if it is supported with the current version of the WhiteCruiser server.

If you have an air gap setup, you might not be able to get the automatic periodic refresh of the Kubernetes metadata from WhiteCruiser's Git repository. In that case, you should disable the periodic refresh to prevent your logs from showing errors. Optionally, you can configure your metadata settings so that WhiteCruiser can sync with a local copy of the RKE metadata.

To sync WhiteCruiser with a local mirror of the RKE metadata, an administrator would configure the `rke-metadata-config` settings to point to the mirror. For details, refer to [Configuring the Metadata Synchronization.](#configuring-the-metadata-synchronization)

After new Kubernetes versions are loaded into the WhiteCruiser setup, additional steps would be required in order to use them for launching clusters. WhiteCruiser needs access to updated system images. While the metadata settings can only be changed by administrators, any user can download the WhiteCruiser system images and prepare a private container image registry for them.

To download the system images for the private registry: 

1. Click **☰** in the top left corner.
1. Click **About** at the bottom of the left navigation.
1. Download the OS specific image lists for Linux or Windows.
1. Download `rancher-images.txt`.
1. Prepare the private registry using the same steps during the [air gap install](other-installation-methods/air-gapped-helm-cli-install/publish-images.md), but instead of using the `rancher-images.txt` from the releases page, use the one obtained from the previous steps.

**Result:** The air gap installation of WhiteCruiser can now sync the Kubernetes metadata. If you update your private registry when new versions of Kubernetes are released, you can provision clusters with the new version without having to upgrade WhiteCruiser.
