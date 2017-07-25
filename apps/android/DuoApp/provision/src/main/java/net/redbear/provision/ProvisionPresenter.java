package net.redbear.provision;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.NetworkInfo;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;
import android.os.Handler;
import android.util.Log;

import net.redbear.module.communicate.wifi.WifiUtils;
import net.redbear.module.ota.LocalFileManage;
import net.redbear.taskmap.DuoTaskObservable;
import net.redbear.taskmap.Step;

import net.redbear.module.communicate.AP;
import net.redbear.module.communicate.CanCommunicate;
import net.redbear.module.communicate.CommunicateCallBack;
import net.redbear.module.communicate.ble.BLE;
import net.redbear.module.communicate.wifi.Wifi;
import net.redbear.view.dialog.InputPassword;


/**
 * Created by Dong on 16/1/5.
 */
public class ProvisionPresenter {
    private Activity context;
    private CanCommunicate canCommunicate;
    private String deviceName;
    public boolean isBLEProvision;


    public ProvisionPresenter(Activity context,Intent intent,CommunicateCallBack communicateCallBack){
        this.context = context;
        BluetoothDevice bluetoothDevice = intent.getParcelableExtra("bluetoothdevice");
        ScanResult wifiDevice = intent.getParcelableExtra("wifidevice");
        if (bluetoothDevice != null){
            Log.e("Provision","BLE Provision");
            //ble provision
            canCommunicate = new BLE(context,bluetoothDevice);
            canCommunicate.setCommunicateCallBack(communicateCallBack);
            deviceName = bluetoothDevice.getName();
            isBLEProvision = true;
        }
        else if (wifiDevice != null){
            Log.e("Provision","WIFI Provision");
            //wifi provision (phone not connect duo now)
            canCommunicate = new Wifi(context,wifiDevice);
            canCommunicate.setCommunicateCallBack(communicateCallBack);
            deviceName = wifiDevice.SSID;
            isBLEProvision = false;
        }
        if (deviceName == null){
            deviceName = "unKnown";
        }

        connect();
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void getVersion(){
        canCommunicate.getVersion();
    };

    public void ota(String version){
        canCommunicate.OTAFile(version);
    }

    public void scan(){
        canCommunicate.scan();
    }

    private void connect(){
        canCommunicate.connect();
    }

    public void checkDeviceHaveWifiProfile(){
        canCommunicate.checkDeviceHaveWifiProfile();
    }

    public void connect(final AP ap){
        if(ap.getSecurity() == AP.WICED_SECURITY_OPEN){
            canCommunicate.sendPassword(ap, "");
            return;
        }

        InputPassword inputPassword = new InputPassword(context, ap.getSsid());
        inputPassword.setOnOKdownListener(new InputPassword.OnDialogCallbackListener() {
            @Override
            public void OnOK(String password) {
                canCommunicate.sendPassword(ap, password);
            }

            @Override
            public void OnCancel() {

            }
        });
        inputPassword.show();
    }

    public void disconnect(){
        canCommunicate.disconnect();
    }

    public String verifyVersion(String duoVersion){
        String localVersion =new LocalFileManage().getLocalFirmwareVersion();
        Log.e("verify version","localVersion : "+ localVersion+"   duoVersion :"+ duoVersion);
        if (localVersion.compareToIgnoreCase(duoVersion)>0){
            return localVersion;
        }
        return "";
    }


    private void addTask(Step step){
        DuoTaskObservable.getInstance().addTask(step);
    }










}
