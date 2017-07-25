package net.redbear.redbearduo.data.communication.ble;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;

import net.redbear.redbearduo.view.Activity.MApplication;

/**
 * Created by Dong on 15/12/29.
 */
public class DuoBLEUtils {

    static public boolean ble_check_support() {
        //check BLE is supported on net.redbear.redbearduo.data.device or not
        if(! MApplication.getMApplication().getPackageManager().hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)) {
            return false;
        }
        return true;
    }

    static public boolean ble_open(Activity activity,int requestCode) {
        final BluetoothManager bluetoothManager = (BluetoothManager) MApplication.getMApplication().getSystemService(Context.BLUETOOTH_SERVICE);
        if(!bluetoothManager.getAdapter().isEnabled()) {
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            activity.startActivityForResult(enableBtIntent, requestCode);
            return true;
        }
        return false;
    }

    static public boolean ble_is_on() {
        final BluetoothManager bluetoothManager = (BluetoothManager) MApplication.getMApplication().getSystemService(Context.BLUETOOTH_SERVICE);
        if(bluetoothManager.getAdapter().isEnabled()) {
            return true;
        }
        return false;
    }

    static public String getService_UUID_from_scanRecord(byte[] bytes) {

        int start = 0;
        while (start < bytes.length-2) {
            if(Integer.toHexString(bytes[start+1] & 0xff).equals("6") || Integer.toHexString(bytes[start+1] & 0xff).equals("7")) {
                int len = new Integer(bytes[start]).intValue() -1;
                String Uuid = "";
                for (int i = start+len+1; i >= (start+2); i--) {
                    String temp = Integer.toHexString(bytes[i] & 0xff);
                    if (temp.equals("0")) {
                        temp = "00";
                    }
                    Uuid += temp;
                    if ((Uuid.length() == 8) || (Uuid.length() == 13) || (Uuid.length() == 18) || (Uuid.length() == 23)){
                        Uuid += "-";
                    }
                }
                return Uuid;
            } else {
                start +=  (new Integer(bytes[start]& 0xff).intValue()+1);
            }
        }
        return "";
    }
}
