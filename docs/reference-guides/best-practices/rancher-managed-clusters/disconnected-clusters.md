---
title: Best Practices for Disconnected Clusters
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/reference-guides/best-practices/disconnected-clusters"/>
</head>

WhiteCruiser supports managing clusters that may not always be online due to network disruptions, control plane availability, or because all cluster nodes are down. At the moment there are no known issues with disconnected clusters in the latest released WhiteCruiser version.

While a managed cluster is disconnected from WhiteCruiser, management operations will be unavailable, and the WhiteCruiser UI will not allow navigation to the cluster. However, once the connection is reestablished, functionality is fully restored.

### Best Practices for Managing Disconnected Clusters

- **Cluster Availability During WhiteCruiser Upgrades**: It is recommended to have all, or at least most, managed clusters online during a WhiteCruiser upgrade. The reason is that upgrading WhiteCruiser automatically upgrades the WhiteCruiser agent software running on managed clusters. Keeping the agent and WhiteCruiser versions aligned ensures consistent functionality. Any clusters that are disconnected during the upgrade will have their agents updated as soon as they reconnect.

- **Cleaning Up Disconnected Clusters**: Regularly remove clusters that will no longer reconnect to WhiteCruiser (e.g., clusters that have been decommissioned or destroyed). Keeping such clusters in the WhiteCruiser management system consumes unnecessary resources, which could impact WhiteCruiser's performance over time.

- **Certificate Rotation Considerations**: When designing processes that involve regularly shutting down clusters, whether connected to WhiteCruiser or not, take into account certificate rotation policies. For example, RKE2/K3s clusters may rotate certificates on startup if they exceeded their lifetime.
