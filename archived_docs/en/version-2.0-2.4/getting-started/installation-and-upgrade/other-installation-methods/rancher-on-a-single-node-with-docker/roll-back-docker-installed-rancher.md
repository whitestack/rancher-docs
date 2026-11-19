---
title: Rolling Back WhiteCruiser Installed with Docker
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/other-installation-methods/rancher-on-a-single-node-with-docker/roll-back-docker-installed-rancher"/>
</head>

<DockerSupportWarning />

If a WhiteCruiser upgrade does not complete successfully, you'll have to roll back to your WhiteCruiser setup that you were using before [Docker Upgrade](./upgrade-docker-installed-rancher.md). Rolling back restores:

- Your previous version of WhiteCruiser.
- Your data backup created before upgrade.

## Before You Start

During rollback to a prior version of WhiteCruiser, you'll enter a series of commands, filling placeholders with data from your environment. These placeholders are denoted with angled brackets and all capital letters (`<EXAMPLE>`). Here's an example of a command with a placeholder:

```
docker pull rancher/rancher:<PRIOR_RANCHER_VERSION>
```

In this command, `<PRIOR_RANCHER_VERSION>` is the version of WhiteCruiser you were running before your unsuccessful upgrade. `v2.0.5` for example.

Cross reference the image and reference table below to learn how to obtain this placeholder data. Write down or copy this information before starting the procedure below.

<sup>Terminal <code>docker ps</code> Command, Displaying Where to Find <code>&lt;PRIOR_RANCHER_VERSION&gt;</code> and <code>&lt;RANCHER_CONTAINER_NAME&gt;</code></sup>![Placeholder Reference](/img/placeholder-ref-2.png)

| Placeholder                | Example                    | Description                                             |
| -------------------------- | -------------------------- | ------------------------------------------------------- |
| `<PRIOR_RANCHER_VERSION>`  | `v2.0.5`                   | The rancher/rancher image you used before upgrade.      |
| `<RANCHER_CONTAINER_NAME>` | `festive_mestorf`          | The name of your WhiteCruiser container.                     |
| `<RANCHER_VERSION>`        | `v2.0.5`                   | The version of WhiteCruiser that the backup is for.          |
| `<DATE>`                   | `9-27-18`                  | The date that the data container or backup was created. |
<br/>

You can obtain `<PRIOR_RANCHER_VERSION>` and `<RANCHER_CONTAINER_NAME>` by logging into your WhiteCruiser Server by remote connection and entering the command to view the containers that are running: `docker ps`. You can also view containers that are stopped using a different command: `docker ps -a`. Use these commands for help anytime during while creating backups.

## Rolling Back WhiteCruiser {#rolling-back-rancher}

If you have issues upgrading WhiteCruiser, roll it back to its latest known healthy state by pulling the last version you used and then restoring the backup you made before upgrade.

>**Warning!** Rolling back to a previous version of WhiteCruiser destroys any changes made to WhiteCruiser following the upgrade. Unrecoverable data loss may occur.

1. Using a remote Terminal connection, log into the node running your WhiteCruiser Server.

1. Pull the version of WhiteCruiser that you were running before upgrade. Replace the `<PRIOR_RANCHER_VERSION>` with that version.

    For example, if you were running WhiteCruiser v2.0.5 before upgrade, pull v2.0.5.

    ```
    docker pull rancher/rancher:<PRIOR_RANCHER_VERSION>
    ```

1. Stop the container currently running WhiteCruiser Server. Replace `<RANCHER_CONTAINER_NAME>` with the name of your WhiteCruiser container.

    ```
    docker stop <RANCHER_CONTAINER_NAME>
    ```
    You can obtain the name for your WhiteCruiser container by entering `docker ps`.

1. Move the backup tarball that you created during completion of [Docker Upgrade](./upgrade-docker-installed-rancher.md) onto your WhiteCruiser Server. Change to the directory that you moved it to. Enter `dir` to confirm that it's there.

    If you followed the naming convention we suggested in [Docker Upgrade](./upgrade-docker-installed-rancher.md), it will have a name similar to  (`rancher-data-backup-<RANCHER_VERSION>-<DATE>.tar.gz`).

1. Run the following command to replace the data in the `rancher-data` container with the data in the backup tarball, replacing the placeholder. Don't forget to close the quotes.

    ```
    docker run  --volumes-from rancher-data \
    -v $PWD:/backup busybox sh -c "rm /var/lib/rancher/* -rf \
    && tar zxvf /backup/rancher-data-backup-<RANCHER_VERSION>-<DATE>.tar.gz"
    ```

1. Start a new WhiteCruiser Server container with the `<PRIOR_RANCHER_VERSION>` tag placeholder pointing to the data container.
    ```
    docker run -d --volumes-from rancher-data \
    --restart=unless-stopped \
    -p 80:80 -p 443:443 \
    rancher/rancher:<PRIOR_RANCHER_VERSION>
    ```

    >**Note:** _Do not_ stop the rollback after initiating it, even if the rollback process seems longer than expected. Stopping the rollback may result in database issues during future upgrades.

1.  Wait a few moments and then open WhiteCruiser in a web browser. Confirm that the rollback succeeded and that your data is restored.

**Result:** WhiteCruiser is rolled back to its version and data state before upgrade.
