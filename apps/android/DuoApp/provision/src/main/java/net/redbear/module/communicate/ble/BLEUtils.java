package net.redbear.module.communicate.ble;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.content.Intent;

/**
 * Created by Dong on 15/12/29.
 */
public class BLEUtils {
    public static final String DuoProvisionServiceUUID = "3EC61400-89CD-49C3-A0D9-7A85669E901E";
    public static final String CommandUUID    = "3EC61401-89CD-49C3-A0D9-7A85669E901E";
    public static final String StateUUID      = "3EC61402-89CD-49C3-A0D9-7A85669E901E";

    public static final int BLE_PROVISION_COMMAND_SCAN              = 0xa0;
    public static final int BLE_PROVISION_COMMAND_CONFIG_AP         = 0xa1;
    public static final int BLE_PROVISION_COMMAND_CONNECT_AP        = 0xa2;
    public static final int BLE_PROVISION_COMMAND_NOTIFY_AP         = 0xa3;
    public static final int BLE_PROVISION_COMMAND_GET_SYS_INFO      = 0xa4;
    public static final int BLE_PROVISION_COMMAND_NOTIFY_IP_CONFIG  = 0xa5;


    public static final int DUO_STATE_SCANNING = 0xb1;
    public static final int DUO_STATE_SCAN_COMPLETE = 0xb2;
    public static final int DUO_STATE_CONFIG_AP = 0xb3;
    public static final int DUO_STATE_CONNECTING = 0xb4;
    public static final int DUO_STATE_CONNECT_COMPLETE = 0xb5;
    public static final int DUO_STATE_CONNECT_FAILED = 0xb6;



    public static byte[] getDataByCMD(int CMD){
        return new byte[]{2,(byte)CMD};
    }

    public static int[] arrayAdd(int[] a1,int[] a2) throws BleDataReceiveException {
        if (a1 == null || a2 == null)
            throw new BleDataReceiveException("array null");
        int[] temp = new int[a1.length+a2.length];
        for (int i=0;i<temp.length;i++){
            if (i < a1.length){
                temp[i] = a1[i];
            }else {
                temp[i] = a2[i-a1.length];
            }
        }
        return temp;
    }

    public static int[] arrayAdd(int[] a1,int[] a2,int exceptFirstN){
        if (a2.length < exceptFirstN)
            return a1;
        int[] temp = new int[a1.length+a2.length-exceptFirstN];
        for (int i=0;i<temp.length;i++){
            if (i < a1.length){
                temp[i] = a1[i];
            }else {
                temp[i] = a2[i-a1.length+2];
            }
        }
        return temp;
    }
    static public void closeBluetooth(Context context) {
        final BluetoothManager bluetoothManager = (BluetoothManager) context.getSystemService(Context.BLUETOOTH_SERVICE);
        if(bluetoothManager.getAdapter().isEnabled()) {
            bluetoothManager.getAdapter().disable();
        }
    }
}
