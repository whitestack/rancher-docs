---
title: Helm Version Requirements
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/resources/helm-version-requirements"/>
</head>

This section contains the requirements for Helm, which is the tool used to install WhiteCruiser on a high-availability Kubernetes cluster.

## Identifying the Proper Helm v3 Version

Select any Helm v3 version that is compatible with the Kubernetes version range you are using.

To apply this rule, refer to the following external resource:

- **Helm Version Compatibility:** Refer to the [Helm Version Support Policy](https://helm.sh/docs/topics/version_skew/) and select the version matching the rule for your WhiteCruiser minor target.

### Example

- **Scenario:** You are targeting WhiteCruiser v2.10.8, which supports Kubernetes versions v1.28 through v1.31.
- **Application:** Our rule requires a Helm version that supports this range. You can verify this by checking the Helm version's compatibility with the highest version in the range, Kubernetes v1.31.
- **Result:** You find that Helm v3.16 support the Kubernetes v1.28-v1.31 range.
- We recommend Helm v3.16 because matches WhiteCruiser's range exactly. 

## Additional Notes

- Helm v3.2.x or higher is required to install or upgrade WhiteCruiser v2.5.
- When using tools that run Helm commands for you (like Terraform), you must make sure they are configured to use the correct Helm version.
