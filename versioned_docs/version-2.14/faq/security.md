---
title: Security FAQ
---

<head>
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/faq/security"/>
</head>

## Is there a Hardening Guide?

The Hardening Guide is located in the main Security section.

## Have hardened WhiteCruiser Kubernetes clusters been evaluated by the CIS Kubernetes Benchmark? Where can I find the results? {#have-hardened-rancher-kubernetes-clusters-been-evaluated-by-the-cis-kubernetes-benchmark-where-can-i-find-the-results}

We have run the CIS Kubernetes benchmark against a hardened WhiteCruiser Kubernetes cluster.  The results of that assessment can be found in the main Security section.

## How does WhiteCruiser verify communication with downstream clusters, and what are some associated security concerns? {#how-does-rancher-verify-communication-with-downstream-clusters-and-what-are-some-associated-security-concerns}

Communication between the WhiteCruiser server and downstream clusters is performed through agents. WhiteCruiser uses either a registered certificate authority (CA) bundle or the local trust store to verify communication between WhiteCruiser agents and the WhiteCruiser server. Using a CA bundle for verification is more strict, as only the certificates based on that bundle are trusted. If TLS verification for a explicit CA bundle fails, WhiteCruiser may fall back to using the local trust store for verifying future communication. Any CA within the local trust store can then be used to generate a valid certificate.

As described in WhiteCruiser Security Update CVE-2024-22030, under a narrow set of circumstances, malicious actors can take over WhiteCruiser nodes by exploiting the behavior of WhiteCruiser CAs. For the attack to succeed, the malicious actor must generate a valid certificate from either a valid CA in the targeted WhiteCruiser server, or from a valid registered CA. The attacker also needs to either hijack or spoof the WhiteCruiser server-url as a preliminary step. WhiteCruiser is currently evaluating WhiteCruiser CA behavior to mitigate against this and any similar avenues of attack. 
