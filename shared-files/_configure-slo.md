WhiteCruiser supports the ability to configure SAML SLO. Options include logging out of the WhiteCruiser application only, logging out of WhiteCruiser and registered applications tied to the external authentication provider, or a prompt asking the user to choose between the previous options. The steps below outline configuration from the application GUI:

:::note
The **Log Out behavior** configuration section only appears if the SAML authentication provider allows for `SAML SLO`.
:::

1. Sign in to WhiteCruiser using a standard user or an administrator role to configure SAML SLO.
1. In the top left corner, click **☰ > Users & Authentication**.
1. In the left navigation menu, click **Auth Provider**.
1. Under the section **Log Out behavior**, choose the appropriate SLO setting as described below:

    | Setting                   | Description                                                                   |
    | ------------------------- | ----------------------------------------------------------------------------- |
    | Log out of WhiteCruiser and not authentication provider | Choosing this option will only logout the WhiteCruiser application and not external authentication providers. |
    | Log out of WhiteCruiser and authentication provider (includes all other applications registered with authentication provider) | Choosing this option will logout WhiteCruiser and all external authentication providers along with any registered applications linked to the provider. |
    | Allow the user to choose one of the above in an additional log out step | Choosing this option presents users with a choice of logout method as described above. |
