# Tunnelblick

Tunnelblick is a free, open-source GUI (graphical user interface) for OpenVPN
on macOS and OS X: More details can be found [here](https://tunnelblick.net/).
Access to a VPN server — your computer is one end of the tunnel and the VPN
server is the other end.

## Find your client account credentials

You need to contact your project administrator to get your own OpenVPN
configuration file (file with .ovpn extension). Download it and Keep it in your
local machine so in next steps we can use this configuration client profile file.

## Download and install Tunnelblick

1. Download [Tunnelblick](https://tunnelblick.net/index.html), a free and
user-friendly app for managing OpenVPN connections on macOS.

    ![Tunnelblick Download](images/tunnelblick_download.png)

2. Navigate to your Downloads folder and double-click the Tunnelblick
installation file (.dmg installer file) you have just downloaded.

    ![dmg Installer File](images/dmg_installer.png)

3. In the window that opens, **double-click** on the Tunnelblick icon.

    ![Tunnelblick Interface](images/tunnelblick_interface.png)

4. A new dialogue box will pop up, asking you if you are sure you want to open
the app. Click **Open**.

    ![Popup Open Confirmation](images/popup_open.png)

    ![Access Popup](images/access_popup.png)

5. You will be asked to enter your device password. Enter it and click **OK**:

    ![User Password prompt to Authorize](images/user_to_authorize.png)

6. Select **Allow** or **Don't Allow** for your notification preference.

    ![Notification Settings](images/notification_settings.png)

7. Once the installation is complete, you will see a pop-up notification asking
you if you want to launch Tunnelblick now. *(An administrator username and
password will be required to secure Tunnelblick).* Click **Launch**.

**Alternatively,** you can click on the **Tunnelblick icon** in the status bar
and select **VPN Details...**:

![VPN Details Menu](images/vpn_details_menu.png)

![Configuration](images/configuration.png)

## Set up the VPN with Tunnelblick

1. A new dialogue box will appear. Click **I have configuration files**.

    ![Configuration File Options](images/configuration_file_options.png)

2. Another notification will pop-up, instructing you how to import
configuration files. Click **OK**.

    ![Add A Configuration](images/add_a_config.png)

3. Drag and drop the previously downloaded .ovpn file from your Downloads
folder to the **Configurations** tab in Tunnelblick.

    ![Load Client Config File](images/client_config_file.png)

    **OR,**

    You can just **drag and drop** the provided OpenVPN configuration file (file
    with .ovpn extension) directly to Tunnelblick icon in status bar at the
    top-right corner of your screen.

    ![Load config on Tunnelblick](images/tunnelblick_app_icon.png)

4. A pop-up will appear, asking you if you want to install the configuration
profile for your current user only or for all users on your Mac. Select your
preferred option. If the VPN is intended for all accounts on your Mac, select
**All Users**. If the VPN will only be used by your current account, select
**Only Me**.

    ![Configuration Installation Setting](images/installation_setting.png)

5. You will be asked to enter your Mac password.

    ![User Login for Authentication](images/user_authentication.png)

    ![Loaded Client Configuration](images/configuration_mac.png)

    Then the screen reads "**Tunnelblick successfully: installed one configuration**".

    ![VPN Configuration Installed Successfully](images/client_config_installed_successfully.png)

You can see the configuration setting is loaded and installed successfully.

## Connect to a VPN server location

1. To connect to a VPN server location, click the Tunnelblick icon in status
bar at the top-right corner of your screen.

    ![Tunnelblick icon in status bar](images/tunnelblick_icon.png)

2. From the drop down menu select the server and click **Connect** **[name of
the .ovpn configuration file]**..

    ![Connect VPN](images/connect_vpn.png)

    **Alternatively,** you can select "**VPN Details**" from the menu and then
    click the "**Connect**"button:

    ![Tunnelblick Configuration Interface](images/tunnelblick_configuration_interface.png)

    This will show the connection log on the dialog:

    ![Connection Log](images/logs.png)

3. When you are connected to OpenVPN server successfully, you will see popup
message as shown below. That's it! You are now connected to a VPN.

    ![Tunnel Successful](images/tunnel_successful.png)

4. Once you are connected to the OpenVPN server, you can run commands like
shown below to connect to the private instances:

    ```sh
    ssh ubuntu@192.168.0.40 -A -i cloud.key
    ```

    ![Private Instance SSH Accessible](images/private_instance_accessible.png)

## Disconnect VPN server

To disconnect, click on the Tunnelblick icon in your status bar and select
**Disconnect** in the drop-down menu.

![Disconnect using Tunnelblick icon](images/disconnect_using_tunnelblick_icon.png)

While closing the log will be shown on popup as shown below:
![Preview Connection Log](images/preview_connection_log.png)

---
