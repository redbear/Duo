package net.redbear.redbearduo.data.communication.ble;

/**
 * Created by Dong on 15/12/29.
 */
public interface BLEUtils {
    String DuoProvisionServiceUUID = "3EC61400-89CD-49C3-A0D9-7A85669E901E";
    String CommandUUID    = "3EC61401-89CD-49C3-A0D9-7A85669E901E";
    String StateUUID      = "3EC61402-89CD-49C3-A0D9-7A85669E901E";

    int DUO_STATE_SCANNING = 0xb1;
    int DUO_STATE_SCAN_COMPLETE = 0xb2;
    int DUO_STATE_CONNECTING = 0xb3;
    int DUO_STATE_CONNECT_COMPLETE = 0xb4;

    int BLE_PROVISION_COMMAND_SCAN = 0xa0;
    int BLE_PROVISION_COMMAND_PASSWORD = 0xa1;
    int BLE_PROVISION_COMMAND_SYSTEM_INFO = 0xa2;

}
