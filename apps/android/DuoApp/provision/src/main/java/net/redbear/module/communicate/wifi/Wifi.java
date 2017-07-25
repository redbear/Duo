package net.redbear.module.communicate.wifi;

import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.NetworkInfo;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;
import android.os.Handler;
import android.util.Log;
import java.io.IOException;
import java.io.InputStream;
import java.security.PublicKey;
import net.redbear.module.communicate.AP;
import net.redbear.module.communicate.CanCommunicate;
import net.redbear.module.communicate.CommunicateCallBack;
import net.redbear.module.communicate.wifi.command.CheckDeviceHaveWifiProfile;
import net.redbear.module.communicate.wifi.command.Command;
import net.redbear.module.communicate.wifi.command.ConfigureApCommand;
import net.redbear.module.communicate.wifi.command.ConnectAp;
import net.redbear.module.communicate.wifi.command.GetDeviceID;
import net.redbear.module.communicate.wifi.command.GetPublicKey;
import net.redbear.module.communicate.wifi.command.GetVersion;
import net.redbear.module.communicate.wifi.command.Response;
import net.redbear.module.communicate.wifi.command.ScanAP;
import net.redbear.module.communicate.wifi.command.SendFirmwareHead;
import net.redbear.module.communicate.wifi.command.WifiSendDataService;
import net.redbear.module.ota.LocalFileManage;
import net.redbear.module.ota.OTAManage;

import okio.BufferedSink;
import okio.BufferedSource;
import okio.Okio;

/**
 * Created by Dong on 16/1/7.
 */
public class Wifi implements CanCommunicate {

    private Context context;
    private WifiManager wifiManager;
    private ScanResult wifiDevice;
    private CommunicateCallBack communicateCallBack;
    boolean GetDeviceIDFlg = false;
    boolean connect = false;

    public Wifi(Context context,ScanResult wifiDevice){
        wifiManager = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
        this.wifiDevice = wifiDevice;
        this.context = context;
        registerBroadcast();
    }

    private void checkAP_is_DUO(){
            if (GetDeviceIDFlg)
                return;
            GetDeviceIDFlg = true;
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    GetDeviceIDFlg = false;
                }
            },2000);
            Command command = new GetDeviceID();
            WifiSendDataService.getProvisionSocket().sendData(command.getCommandData(), 1, 10, new WifiSendDataService.DataResponseCallBack() {
                @Override
                public void callBack(Response data) {
                    if (data == null){
                        communicateCallBack.onConnectTimeout();
                        return;
                    }
                    if (data.responseIsOK()){
                        connect =true;
                        communicateCallBack.onConnectToDuo();
                    }
                }
            }, GetDeviceID.Response.class);

    }


    @Override
    public void connect() {
        if (wifiDevice == null)
            return;
        WifiUtils.connectToAp(wifiManager,wifiDevice.SSID,"",WifiUtils.TYPE_NO_PASSWORD);
    }

    @Override
    public void getVersion() {
        try{
            Command command = new GetVersion();
            WifiSendDataService.getProvisionSocket().sendData(command.getCommandData(), 2, 10, new WifiSendDataService.DataResponseCallBack() {
                @Override
                public void callBack(Response data) {
                    if (communicateCallBack == null || !data.responseIsOK()) {
                        //communicateCallBack.onConnectTimeout();
                        return;
                    } else {
                        communicateCallBack.onGetFirmVersion(((GetVersion.Response) data).releaseVersion);
                    }
                }
            }, GetVersion.Response.class);
        }catch (Exception e){

        }

    }

    @Override
    public void checkDeviceHaveWifiProfile(){
        Command command = new CheckDeviceHaveWifiProfile();
        WifiSendDataService.getProvisionSocket().sendData(command.getCommandData(), 2, 10, new WifiSendDataService.DataResponseCallBack() {
            @Override
            public void callBack(Response data) {
                if (communicateCallBack == null || !data.responseIsOK()) {
                    return;
                } else {
                    communicateCallBack.onCheckDeviceHaveWifiProfile(((CheckDeviceHaveWifiProfile.Response) data).hasCredentials == 1);
                }
            }
        }, CheckDeviceHaveWifiProfile.Response.class);
    }


    @Override
    public void OTAFile(String version) {
        communicateCallBack.onOTALogBack("OTA begin" + "\n" + "sending system part 1 bin file information", -1,0);
        try {
            otaFile(OTAManage.OTA_REGION_SEC0_ADDR,OTAManage.OTA_File_STORE_OTA, OTAManage.SYSTEM_PART_1_FILE_NAME, 1, new OTAFileCallback() {
                @Override
                public void onOTASuccess() {
                    try {
                        otaFile(OTAManage.OTA_REGION_SEC1_ADDR,OTAManage.OTA_File_STORE_OTA, OTAManage.SYSTEM_PART_2_FILE_NAME, 2, new OTAFileCallback() {
                            @Override
                            public void onOTASuccess() {
                                communicateCallBack.onOTAFinish();
                            }
                        });
                    } catch (IOException e) {
                        Log.e("OTAFile",e.toString());
                    }
                }
            });
        } catch (IOException e) {
            Log.e("OTAFile",e.toString());
        }
    }

    private void otaFile(Integer chunk_address,int file_store, final String fileName, final int task_n, final OTAFileCallback otaFileCallback) throws IOException {
        LocalFileManage fileManage = new LocalFileManage();
        InputStream P1 = fileManage.getBinFromZip(fileName);
        Command command = new SendFirmwareHead(P1.available(),chunk_address,file_store);
        P1.close();
        WifiSendDataService.getProvisionSocket().sendData(command.getCommandData(),2,10, new WifiSendDataService.DataResponseCallBack() {
            @Override
            public void callBack(Response data) {
                if (communicateCallBack == null || data == null ||!data.responseIsOK()){
                    return;
                }else {
                    communicateCallBack.onOTALogBack("send system part "+task_n+" bin file information success",-1,task_n);
                    communicateCallBack.onOTALogBack("send system part "+task_n+" bin file", -1,task_n);
                    try {
                        WifiSendDataService.getOTASocket().sendFile(new LocalFileManage().getBinFromZip(fileName), new WifiSendDataService.OTAResponseCallBack() {
                            @Override
                            public void callBack(int progress) {
                                communicateCallBack.onOTALogBack(null,progress,task_n);
                                if (progress == 100){
                                    communicateCallBack.onOTALogBack("send system part 1 bin file success",-1,task_n);
                                    otaFileCallback.onOTASuccess();
                                }
                            }
                        });
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }, SendFirmwareHead.Response.class);
    }

    @Override
    public void scan() {
        Command command = new ScanAP();
        WifiSendDataService.getProvisionSocket().sendData(command.getCommandData(), 2, 10, new WifiSendDataService.DataResponseCallBack() {
            @Override
            public void callBack(Response data) {
                if (communicateCallBack == null || !data.responseIsOK())
                    return;
                communicateCallBack.onScanComplete(((ScanAP.Response) data).getAps());
            }
        }, ScanAP.Response.class);
    }

    @Override
    public void sendPassword(final AP ap, final String password) {

        communicateCallBack.onConnecting();
        //get public key and then send password
        //getPublicKey(ap, password);
        Command command = new GetPublicKey();
        WifiSendDataService.getProvisionSocket().sendData(command.getCommandData(),2,10, new WifiSendDataService.DataResponseCallBack() {
            @Override
            public void callBack(Response data) {
                if (communicateCallBack == null || !data.responseIsOK()){
                    communicateCallBack.onConnectTimeout();
                    return;
                }
                try {
                    sendPassword(((GetPublicKey.Response)data).publicKey, ap, password);
                }catch (Exception e){
                    communicateCallBack.onBoardConnectToAPError(e);
                }

            }
        }, GetPublicKey.Response.class);



    }

    private void sendPassword(final String publicKey,AP ap, final String password){

        ConfigureApCommand.Builder builder = ConfigureApCommand.newBuilder()
                .setSsid(ap.getSsid())
                .setSecurityType(ap.getSecurity())
                .setChannel(ap.getChannel())
                .setIdx(0);

        if (ap.getSecurity() != AP.WICED_SECURITY_OPEN) {
            try {
                Log.e("generate password....", "networkSecretPlaintext : " + password + "publicKey:  " + publicKey);
                PublicKey publicKey1 = WifiUtils.readPublicKeyFromHexEncodedDerString(publicKey);
                builder.setEncryptedPasswordHex(WifiUtils.encryptAndEncodeToHex(password, publicKey1));
            } catch (Exception e) {
                // FIXME: try to throw a more specific exception here.
                // Don't throw SetupException here -- if this is failing, it's not
                // going to get any better by the running this SetupStep again, and
                // it can really only fail if the surrounding app code is doing something
                // wrong.  To wit: you *want* the app to crash here (or at least
                // throw out a dialog saying "horrible thing happened!  horrible error
                // code: ..." and then return to a safe "default" activity.
                throw new RuntimeException("Error encrypting network credentials", e);
            }
        }

        ConfigureApCommand command = builder.build();
        WifiSendDataService.getProvisionSocket().sendData(command.getCommandData(), 10, 2, new WifiSendDataService.DataResponseCallBack() {
            @Override
            public void callBack(Response data) {
                if (communicateCallBack == null || !data.responseIsOK()){
                    communicateCallBack.onConnectTimeout();
                    return;
                }
                connectAP();
            }
        }, ConfigureApCommand.Response.class);

    }

    @Override
    public void setCommunicateCallBack(CommunicateCallBack communicateCallBack) {
        this.communicateCallBack = communicateCallBack;
    }

    @Override
    public void disconnect() {
        wifiManager.removeNetwork(wifiManager.getConnectionInfo().getNetworkId());
        wifiManager.saveConfiguration();
        wifiManager.disconnect();
        try {
            context.unregisterReceiver(mWifiReceiver);
        }catch (Exception e){

        }
    }

    private void connectAP(){

        Command command = new ConnectAp();
        WifiSendDataService.getProvisionSocket().sendData(command.getCommandData(),2,10, new WifiSendDataService.DataResponseCallBack() {
            @Override
            public void callBack(Response data) {
                if (communicateCallBack == null || !data.responseIsOK()){
                    communicateCallBack.onConnectTimeout();
                    return;
                }else {
                    communicateCallBack.onConnectComplete(null);
                }
            }
        }, ConnectAp.Response.class);

    }

    private void registerBroadcast(){
        IntentFilter filter = new IntentFilter();
        filter.addAction(WifiManager.WIFI_STATE_CHANGED_ACTION);
        filter.addAction(WifiManager.NETWORK_STATE_CHANGED_ACTION);
        context.registerReceiver(mWifiReceiver, filter);
    }

    private BroadcastReceiver mWifiReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(final Context context, Intent intent) {
            if (intent != null) {
                if (WifiManager.WIFI_STATE_CHANGED_ACTION.equals(intent.getAction())) {
                    int wifiState = intent.getIntExtra(WifiManager.EXTRA_WIFI_STATE, 0);
                    switch (wifiState) {
                        case WifiManager.WIFI_STATE_DISABLED:
                            communicateCallBack.onDisconnectFromDuo("");
                            break;
                        case WifiManager.WIFI_STATE_ENABLED:
                            break;
                    }
                }
                if (WifiManager.NETWORK_STATE_CHANGED_ACTION.equals(intent.getAction())) {
                    NetworkInfo info = intent.getParcelableExtra(WifiManager.EXTRA_NETWORK_INFO);
                    if(info.getState().equals(NetworkInfo.State.DISCONNECTED)){
                        if (connect)
                            communicateCallBack.onDisconnectFromDuo("");
                    }
                    if(info.getState().equals(NetworkInfo.State.CONNECTED)){
                        new Handler().postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                if (WifiUtils.get_phone_connected_ap_ssid(context).equals("\""+wifiDevice.SSID+"\"")){
                                    checkAP_is_DUO();
                                }
                            }
                        },1000);
                    }
                }
            }
        }
    };

}
