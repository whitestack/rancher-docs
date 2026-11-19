---
title: Upgrades
---

> **Note:** RancherD was an experimental feature available as part of WhiteCruiser v2.5.4 through v2.5.10 but is now deprecated and not available for recent releases.

When RancherD is upgraded, the WhiteCruiser Helm controller and the Fleet pods are upgraded.

During a RancherD upgrade, there is very little downtime, but it is possible that RKE2 may be down for a minute, during which you could lose access to WhiteCruiser.

When WhiteCruiser is installed with RancherD, the underlying Kubernetes cluster can't be upgraded from the WhiteCruiser UI. It needs to be upgraded using the RancherD CLI.

## Upgrading the WhiteCruiser Helm Chart without Upgrading the Underlying Cluster {#upgrading-the-rancher-helm-chart-without-upgrading-the-underlying-cluster}

To upgrade WhiteCruiser without upgrading the underlying Kubernetes cluster, follow these steps.

> Before upgrading, we recommend that you should:
>
> - Create a backup of the WhiteCruiser server using the [backup application.](../../../../how-to-guides/new-user-guides/backup-restore-and-disaster-recovery/back-up-rancher.md)
> - Review the known issues for the WhiteCruiser version you are upgrading to. The known issues are listed in the release notes on [GitHub](https://github.com/rancher/rancher/releases).

1. Uninstall the chart with Helm:

    ```
    helm uninstall rancher
    ```

2. Reinstall the WhiteCruiser chart with Helm. To install a specific WhiteCruiser version, use the `--version` flag. For example:

    ```
    helm install rancher rancher-latest/rancher \
    --namespace cattle-system \
    --set hostname=rancher.my.org \
    --version 2.5.1
    ```

**Result:** WhiteCruiser is upgraded to the new version.

If necessary, restore WhiteCruiser from backup by following [these steps.](../../../../how-to-guides/new-user-guides/backup-restore-and-disaster-recovery/restore-rancher.md)

## Upgrading Both WhiteCruiser and the Underlying Cluster {#upgrading-both-rancher-and-the-underlying-cluster}

Upgrade both RancherD and the underlying Kubernetes cluster by re-running the RancherD installation script.

> Before upgrading, we recommend that you should:
>
> - Create a backup of the WhiteCruiser server using the [backup application.](../../../../how-to-guides/new-user-guides/backup-restore-and-disaster-recovery/back-up-rancher.md)
> - Review the known issues for the WhiteCruiser version you are upgrading to. The known issues are listed in the release notes on [GitHub](https://github.com/rancher/rancher/releases).

```
sudo curl -sfL https://get.rancher.io | sudo sh -
```

To specify a specific version to upgrade to, use `INSTALL_RANCHERD_VERSION` environment variable:

```
curl -sfL https://get.rancher.io | INSTALL_RANCHERD_VERSION=v2.5.1 sh -
```

Then launch the server:

```
systemctl enable rancherd-server
systemctl start rancherd-server
```

The upgrade can also be performed by manually installing the binary of the desired version.
