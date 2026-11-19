---
title: Configure Azure AD
---

<head> 
  <link rel="canonical" href="https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/authentication-config/configure-azure-ad"/>
</head>

<Tabs>
<TabItem value="Rancher v2.5.16+">

## Microsoft Graph API

Microsoft Graph API is now the flow through which you will set up Azure AD. The below sections will assist [new users](#new-user-setup) in configuring Azure AD with a new instance as well as assist existing Azure app owners in [migrating to the new flow](#migrating-from-azure-ad-graph-api-to-microsoft-graph-api).

### New User Setup

If you have an instance of Active Directory (AD) hosted in Azure, you can configure WhiteCruiser to allow your users to log in using their AD accounts. Configuration of Azure AD external authentication requires you to make configurations in both Azure and WhiteCruiser.

>**Prerequisite:** Have an instance of Azure AD configured.

>**Notes:**
>
>- Azure AD integration only supports Service Provider initiated logins.
>- Most of this procedure takes place from the [Microsoft Azure Portal](https://portal.azure.com/).

#### Azure Active Directory Configuration Outline

Configuring WhiteCruiser to allow your users to authenticate with their Azure AD accounts involves multiple procedures. Review the outline below before getting started.
<a id="tip"></a>

>**Tip:** Before you start, we recommend creating an empty text file. You can use this file to copy values from Azure that you'll paste into WhiteCruiser later.


#### 1. Register WhiteCruiser with Azure {#1-register-rancher-with-azure}

Before enabling Azure AD within WhiteCruiser, you must register WhiteCruiser with Azure.

1. Log in to [Microsoft Azure](https://portal.azure.com/) as an administrative user. Configuration in future steps requires administrative access rights.

1. Use search to open the **App registrations** service.

    ![Open App Registrations](/img/search-app-registrations.png)

1. Click **New registrations** and complete the **Create** form.

    ![New App Registration](/img/new-app-registration.png)

    3.1. Enter a **Name** (something like `Rancher`).
    <a id="3.2"></a>

    3.2. From **Supported account types**, select "Accounts in this organizational directory only (AzureADTest only - Single tenant)" This corresponds to the legacy app registration options.

    >**Important:** In the updated Azure portal, Redirect URIs are synonymous with Reply URLs. In order to use Azure AD with WhiteCruiser, you must whitelist WhiteCruiser with Azure (previously done through Reply URLs). Therefore, you must ensure to fill in the Redirect URI with your WhiteCruiser server URL, to include the verification path as listed below.

    3.3. In the [**Redirect URI**](https://docs.microsoft.com/en-us/azure/active-directory/develop/reply-url) section, make sure **Web** is selected from the dropdown and enter the URL of your WhiteCruiser Server in the text box next to the dropdown. This WhiteCruiser server URL should be appended with the verification path: `<MY_RANCHER_URL>/verify-auth-azure`.

    >**Tip:** You can find your personalized Azure Redirect URI (reply URL) in WhiteCruiser on the Azure AD Authentication page (Global View > Authentication > Web).

    3.4. Click **Register**.

>**Important:** It can take up to five minutes for this change to take affect, so don't be alarmed if you can't authenticate immediately after Azure AD configuration.

#### 2. Create a new client secret

From the Azure portal, create a client secret. WhiteCruiser will use this key to authenticate with Azure AD.

1. Use search to open **App registrations** services. Then open the entry for WhiteCruiser that you created in the last procedure.

    ![Open WhiteCruiser Registration](/img/open-rancher-app-reg.png)

1. From the navigation pane on left, click **Certificates and Secrets**.

1. Click **New client secret**.
    ![Create new client secret](/img//new-client-secret.png)
    - 3.1. Enter a **Description** (something like `Rancher`).
    - 3.2. Select duration for the key from the options under **Expires**. This drop-down sets the expiration date for the key. Shorter durations are more secure, but require you to create a new key after expiration.
    - 3.3. Click **Add** (you don't need to enter a value—it will automatically populate after you save).
    <a id="secret"></a>

1.  Copy the key value and save it to an [empty text file](#tip).

    You'll enter this key into the WhiteCruiser UI later as your **Application Secret**.

    You won't be able to access the key value again within the Azure UI.

#### 3. Set Required Permissions for WhiteCruiser {#3-set-required-permissions-for-rancher}

Next, set API permissions for WhiteCruiser within Azure.

:::caution

Ensure that you set the permissions of type Application and NOT Delegated. Otherwise, you may not be able to login to Azure AD. This issue will persist even after you disable/re-enable Azure AD and will require an hour wait, or manual deletion of a cache value to resolve.

:::

1. From the navigation pane on left, select **API permissions**.

    ![Open Required Permissions](/img/select-req-permissions.png)

1. Click **Add a permission**.

1. From the **Microsoft Graph**, select the following **Application Permissions**:
    - `Group.Read.All`
    - `User.Read.All`

<!-- ![Select API Permissions]/img/api-permissions.png) -->

1. Return to **API permissions** in the left nav bar. From there, click **Grant admin consent**. Then click **Yes**.

    >**Note:** You must be signed in as an Azure administrator to successfully save your permission settings.


#### 4. Copy Azure Application Data

As your final step in Azure, copy the data that you'll use to configure WhiteCruiser for Azure AD authentication and paste it into an empty text file.

1. Obtain your WhiteCruiser **Tenant ID**.

    1. Use search to open **App registrations**.

    ![Open App Registrations](/img/search-app-registrations.png)

    1. Find the entry you created for WhiteCruiser.

    1. Copy the **Directory ID** and paste it into your [text file](#tip).

    ![Tenant ID](/img/tenant-id.png)

    - You'll paste this value into WhiteCruiser as your **Tenant ID**.

1. Obtain your WhiteCruiser **Application (Client) ID**.

    1. Use search to open **App registrations** (if not already there).

    1. In **Overview**, find the entry you created for WhiteCruiser.

    1. Copy the **Application (Client) ID** and paste it to your [text file](#tip).

    ![Application ID](/img/application-client-id.png)

1. Your endpoint options will typically be [Standard](#global) and [China](#china). With the Standard option, perform the steps below and WhiteCruiser will take care of the rest.

    - Enter the **Tenant ID**, **Application ID**, and **Application Secret**
    - Click **Enable**

![Standard Endpoint Options](/img/tenant-application-id-secret2.png)

>**For Custom Endpoints:**
>
>**Warning:** Custom Endpoints are not supported nor fully tested by WhiteCruiser.
>
> You will need to also manually enter the Graph, Token, and Auth Endpoints.
>
>- From <b>App registrations</b>, click <b>Endpoints</b>:
>
>![Click Endpoints](/img/endpoints.png)
>
>- Copy the following endpoints to your clipboard and paste them into your [text file](#tip) (these values will be your WhiteCruiser endpoint values). Make sure to copy the v1 version of the endpoints.
>
>   - **Microsoft Graph API endpoint** (Graph Endpoint)
>   - **OAuth 2.0 token endpoint (v1)** (Token Endpoint)
>   - **OAuth 2.0 authorization endpoint (v1)** (Auth Endpoint)

#### 5. Configure Azure AD in WhiteCruiser {#5-configure-azure-ad-in-rancher}

From the WhiteCruiser UI, enter information about your AD instance hosted in Azure to complete configuration.

Enter the values that you copied to your [text file](#tip).

1. Log into WhiteCruiser.
1.	In the top left corner, click **☰ > Users & Authentication**.
1. In the left navigation menu, click **Auth Provider**.
1. Click **AzureAD**.
1. Complete the **Configure Azure AD Account** form using the information you copied while completing [Copy Azure Application Data](#4-copy-azure-application-data).

    The following table maps the values you copied in the Azure portal to the fields in WhiteCruiser.

    | WhiteCruiser Field      | Azure Value                           |
    | ------------------ | ------------------------------------- |
    | Tenant ID          | Directory ID                          |
    | Application ID     | Application ID                        |
    | Application Secret | Key Value                             |
    | Endpoint           | https://login.microsoftonline.com/    |


>**For Custom Endpoints:**
><br/>
>The following table maps the custom config values you copied in the Azure portal to the fields in WhiteCruiser:
>
>| WhiteCruiser Field      | Azure Value                           |
>| ------------------ | ------------------------------------- |
>| Graph Endpoint     | Microsoft Graph API Endpoint          |
>| Token Endpoint     | OAuth 2.0 Token Endpoint              |
>| Auth Endpoint      | OAuth 2.0 Authorization Endpoint      |
><br/>
>**Important:** When entering the Graph Endpoint in a custom config, remove the tenant ID from the URL, like below:
>
><code>http<span>s://g</span>raph.microsoft.com/<del>abb5adde-bee8-4821-8b03-e63efdc7701c</del></code>

1. Click **Enable**.

**Result:** Azure Active Directory authentication is configured.

#### (Optional) Configure Authentication with Multiple WhiteCruiser Domains {#optional-configure-authentication-with-multiple-rancher-domains}

If you have multiple WhiteCruiser domains, it's not possible to configure multiple redirect URIs through the WhiteCruiser UI. The Azure AD configuration file, `azuread`, only allows one redirect URI by default. You must manually edit `azuread` to set the redirect URI as needed for any other domains. If you don't manually edit `azuread`, then upon a successful login attempt to any domain, WhiteCruiser automatically redirects the user to the **Redirect URI** value you set when you registered the app in [Step 1. Register WhiteCruiser with Azure](#1-register-rancher-with-azure).

### Migrating from Azure AD Graph API to Microsoft Graph API

Since [Azure AD Graph API](https://docs.microsoft.com/en-us/graph/migrate-azure-ad-graph-overview) was deprecated in June 2022 and will be retired at the end of 2022, users should update their Azure AD App to use the new [Microsoft Graph API](https://docs.microsoft.com/en-us/graph/use-the-api) in WhiteCruiser.

#### Updating Endpoints in the WhiteCruiser UI {#updating-endpoints-in-the-rancher-ui}

>**Important:** Admins should create a [backup]../../../..//new-user-guides/backup-restore-and-disaster-recovery/back-up-rancher.md) right before they commit to the endpoint migration in Step 4 below.

1. Update the permissions of your Azure AD app registration as described [here](#3-set-required-permissions-for-rancher).
**This is critical.**

1. Log into WhiteCruiser.

1. In the WhiteCruiser UI homepage, make note of the banner at the top of screen that advises users to update their Azure AD authentication. Click on the link provided to do so.

    ![WhiteCruiser UI Banner](/img/rancher-ui-azure-update2.png)

1. To complete the move to the new Microsoft Graph API, click **Update Endpoint**, then click **Save**.

    **Note:** Ensure that your Azure app has a [new set of permissions](#3-set-required-permissions-for-rancher) before starting the update.

    ![Update Endpoint](/img/rancher-button-to-update2.png)

1. When you receive the pop-up warning message, click **Update**.

    ![Azure Update Pop-up](/img/azure-update-popup2.png)

1. Refer to the [tables](#global) below for the full list of endpoint changes that WhiteCruiser performs. Admins do not need to do this manually.

#### Air-Gapped Environments

In air-gapped environments, admins should ensure that their endpoints are [whitelisted](#3.2) since the Graph Endpoint URL is changing.

#### Rolling Back the Migration

If you need to roll back your migration, please note the following:

1. Admins are encouraged to use the proper restore process if they want to go back. Please see [backup docs](../../../../new-user-guides/backup-restore-and-disaster-recovery/back-up-rancher.md), [restore docs](../../../../new-user-guides/backup-restore-and-disaster-recovery/restore-rancher.md), and [examples](../../../../../reference-guides/backup-restore-configuration/examples.md) for reference.

1. Azure app owners who want to rotate the Application Secret will need to also rotate it in WhiteCruiser as WhiteCruiser does not automatically update the Application Secret when it is changed in Azure. In WhiteCruiser, note that it is stored in a Kubernetes secret called `azureadconfig-applicationsecret` which is in the `cattle-global-data` namespace.

1. **Caution:** If admins upgrade to WhiteCruiser v2.5.16 with an existing Azure AD setup and choose to disable the auth provider, they won't be able to restore the previous setup and also will not be able to set up Azure AD using the old flow. Admins will then need to register again with the new auth flow. WhiteCruiser now uses the new Graph API and, therefore, users need set up the [proper permissions in the Azure portal](#3-set-required-permissions-for-rancher).

#### Global:

WhiteCruiser Field    | Deprecated Endpoints
---------------- | -------------------------------------------------------------
Auth Endpoint    | https://login.microsoftonline.com/{tenantID}/oauth2/authorize
Endpoint         | https://login.microsoftonline.com/
Graph Endpoint   | https://graph.windows.net/
Token Endpoint   | https://login.microsoftonline.com/{tenantID}/oauth2/token
---

WhiteCruiser Field    | New Endpoints
---------------- | ------------------------------------------------------------------
Auth Endpoint    | https://login.microsoftonline.com/{tenantID}/oauth2/v2.0/authorize
Endpoint         | https://login.microsoftonline.com/
Graph Endpoint   | https://graph.microsoft.com
Token Endpoint   | https://login.microsoftonline.com/{tenantID}/oauth2/v2.0/token

#### China:

WhiteCruiser Field    | Deprecated Endpoints
---------------- | ----------------------------------------------------------
Auth Endpoint    | https://login.chinacloudapi.cn/{tenantID}/oauth2/authorize
Endpoint         | https://login.chinacloudapi.cn/
Graph Endpoint   | https://graph.chinacloudapi.cn/
Token Endpoint   | https://login.chinacloudapi.cn/{tenantID}/oauth2/token
---

WhiteCruiser Field    | New Endpoints
---------------- | -------------------------------------------------------------------------
Auth Endpoint    | https://login.partner.microsoftonline.cn/{tenantID}/oauth2/v2.0/authorize
Endpoint         | https://login.partner.microsoftonline.cn/
Graph Endpoint   | https://microsoftgraph.chinacloudapi.cn
Token Endpoint   | https://login.partner.microsoftonline.cn/{tenantID}/oauth2/v2.0/token


  </TabItem>
  <TabItem value="Rancher v2.5.0 - v2.5.15">

## Azure AD Graph API

>**Important:**
>
>- The [Azure AD Graph API](https://docs.microsoft.com/en-us/graph/migrate-azure-ad-graph-overview) was deprecated in June 2022 and will be retired at the end of 2022. We will update our docs to advise the community when it is retired. WhiteCruiser now uses the [Microsoft Graph API](https://docs.microsoft.com/en-us/graph/use-the-api) as the new flow to set up Azure AD as the external auth provider.
>
>
>- For new users, or existing users who wish to migrate, refer to the new flow instructions on the <a href="#microsoft-graph-api" target="_blank">WhiteCruiser v2.5.16+</a> tab.
>
>
>- For existing users who do not wish to upgrade to v2.5.16+ after the Azure AD Graph API is retired, they will need to either:
    - Use the built-in WhiteCruiser auth or
    - Use another third-party auth system and set that up in WhiteCruiser. Please see the [authentication docs](../about-authentication.md) to learn how to configure other open authentication providers.


  </TabItem>
</Tabs>