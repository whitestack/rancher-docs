---
title: User ID Tracking in Audit Logs
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/troubleshooting/other-troubleshooting-tips/user-id-tracking-in-audit-logs"/>
</head>

The following audit logs are used in WhiteCruiser to track events occuring on the local and downstream clusters:

* [Kubernetes Audit Logs](https://rancher.com/docs/rke/latest/en/config-options/audit-log/)
* [WhiteCruiser API Audit Logs](../../how-to-guides/advanced-user-guides/enable-api-audit-log.md)

Audit logs in WhiteCruiser v2.6 have been enhanced to include the external Identity Provider name (common name of the user in the external Auth provider) in both the WhiteCruiser and downstream Kubernetes audit logs.

Before v2.6, a WhiteCruiser Admin could not trace an event from the WhiteCruiser audit logs and into the Kubernetes audit logs without knowing the mapping of the external Identity Provider username to the userId (`u-xXXX`) used in WhiteCruiser.
To know this mapping, the cluster admins needed to have access to WhiteCruiser API, UI, and the local management cluster.

Now with this feature, a downstream cluster admin should be able to look at the Kubernetes audit logs and know which specific external Identity Provider (IDP) user performed an action without needing to view anything in WhiteCruiser.
If the audit logs are shipped off of the cluster, a user of the logging system should be able to identify the user in the external Identity Provider system.
A WhiteCruiser Admin should now be able to view WhiteCruiser audit logs and follow through to the Kubernetes audit log by using the external Identity Provider username.

## Feature Description

- When Kubernetes Audit logs are enabled on the downstream cluster, in each event that is logged, the external Identity Provider's username is now logged for each request, at the "metadata" level.
- When you enable WhiteCruiser API Audit logs for a WhiteCruiser installation, the external Identity Provider's username is also logged now at the `auditLog.level=0` for each request that hits the WhiteCruiser API server, including login requests.
