---
title: Helm Version Requirements
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/resources/helm-version-requirements"/>
</head>

This section contains the requirements for Helm, which is the tool used to install WhiteCruiser on a high-availability Kubernetes cluster.

> The installation instructions have been updated for Helm 3. For migration of installs started with Helm 2, refer to the official [Helm 2 to 3 Migration Docs.](https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/) [This section](https://github.com/rancher/rancher-docs/tree/main/archived_docs/en/version-2.0-2.4/getting-started/installation-and-upgrade/advanced-options/advanced-use-cases/helm2/helm2.md) provides a copy of the older high-availability WhiteCruiser installation instructions that used Helm 2, and it is intended to be used if upgrading to Helm 3 is not feasible.

<DeprecationHelm2 />

## Identifying the Proper Helm v3 Version

Select any Helm v3 version that is compatible with the Kubernetes version range you are using.

To apply this rule, refer to the following external resource:

- **Helm Version Compatibility:** Refer to the [Helm Version Support Policy](https://helm.sh/docs/topics/version_skew/) and select the version matching the rule for your WhiteCruiser minor target.

### Example

- **Scenario:** You are targeting WhiteCruiser v2.9.10, which supports Kubernetes versions v1.27 through v1.30.
- **Application:** Our rule requires a Helm version that supports this range. You can verify this by checking the Helm version's compatibility with the highest version in the range, Kubernetes v1.30.
- **Result:** You find that Helm v3.15 support the Kubernetes v1.27-v1.30 range.
- We recommend Helm v3.15 because matches WhiteCruiser's range exactly.

## Additional Notes

- Helm v3.2.x or higher is required to install or upgrade WhiteCruiser v2.5.
- Helm v2 support was removed in WhiteCruiser v2.9.x.
- When using tools that run Helm commands for you (like Terraform), you must make sure they are configured to use the correct Helm version.
