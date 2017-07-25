package net.redbear.redbearduo.presenter;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.NetworkInfo;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;
import android.os.Handler;
import android.support.v7.app.AlertDialog;
import android.util.Log;
import android.widget.TextView;

import net.redbear.board.controller.view.activity.ControlActivity;
import net.redbear.provision.ProvisionMainActivity;
import net.redbear.redbearduo.R;

import java.util.ArrayList;
import java.util.List;

import net.redbear.redbearduo.data.Common;
import net.redbear.redbearduo.data.communication.CommunicationManage;
import net.redbear.redbearduo.data.communication.MDNSManage;
import net.redbear.redbearduo.data.communication.ble.DuoBLE;
import net.redbear.redbearduo.data.communication.ble.DuoBLEUtils;
import net.redbear.redbearduo.data.communication.wifi.DuoWifiUtils;
import net.redbear.redbearduo.data.device.Device;
import net.redbear.redbearduo.view.Activity.MApplication;
import net.redbear.taskmap.Step;
import static net.redbear.redbearduo.data.communication.CommunicationManage.*;

/**
 * Created by Dong on 16/1/4.
 */
public class DeviceScanPresenter {

    private final String TGA = getClass().getSimpleName();
    private Activity context;
    public int connectState;
    private DeviceScanPresenterCallBack deviceScanPresenterCallBack;
    //BLE
    private DuoBLE ble;
    private String[] bleServicesUUIDMask = {Common.PROVISION_UUID, Common.CONTROLLER_UUID};
    //MDNS
    private MDNSManage mdnsManage;

    private ArrayList<Device> devices;

    private CommunicationManage communicationManage;

    private TextView titleView;

    public DeviceScanPresenter(Activity context){
        this.context = context;
        connectState = MApplication.getConnectState();
        Log.e("MApplication.....doNext", MApplication.doNext + "");
        ble = new DuoBLE(context);
        devices = new ArrayList<>();

        mdnsManage = new MDNSManage(context);
        mdnsManage.setOnMDNSDevicesScanCallback(callback);

        communicationManage = new CommunicationManage();
        checkCommunicationSupport();
        registerBroadcast();
    }

    public void setTitleView(TextView titleView){
        this.titleView =titleView;
    }

    private void setTitle(String title){
        if (titleView == null)
            return;
        titleView.setText(title);
    }

    private void checkCommunicationSupport(){
        switch (communicationManage.getCommunicationSupport()){
            case SUPPORT_NONE :
                Log.e("TGA","checkSupport :"+"SUPPORT_NONE");
                addStep(Step.WIFI_NOT_SUPPORT);
                addStep(Step.BLE_NOT_SUPPORT);
                dialogToShow("BLE and Wifi are not Support,please open one of them and restart the application");
                break;
            case SUPPORT_BLE_AND_WIFI:
                Log.e("TGA","checkSupport :"+"SUPPORT_BLE_AND_WIFI");
                addStep(Step.WIFI_SUPPORT);
                addStep(Step.BLE_SUPPORT);
                break;
            case SUPPORT_BLE_ONLY:
                Log.e("TGA","checkSupport :"+"SUPPORT_BLE_ONLY");
                addStep(Step.BLE_SUPPORT);
                addStep(Step.WIFI_NOT_SUPPORT);
                break;
            case SUPPORT_WIFI_ONLY:
                Log.e("TGA", "checkSupport :" + "SUPPORT_WIFI_ONLY");
                addStep(Step.WIFI_SUPPORT);
                addStep(Step.BLE_NOT_SUPPORT);
                break;
        }
    }

    public void notifyCommunicationState(){
        CommunicationState communicationState = communicationManage.getCommunicationState();
        devices.clear();
        switch (communicationState){
            case BLE_OPEN_ONLY:
                Log.e(TGA,"notifyState :"+"BLE_OPEN_ONLY");
                setTitle("BLE Scan");
                deviceScan(communicationState, 5000);
                break;
            case WIFI_OPEN_ONLY:
                Log.e(TGA, "notifyState :" + "WIFI_OPEN_ONLY");
                setTitle("WIFI Scan");
                deviceScan(communicationState, 5000);
                break;
            case WIFI_BLE_OPEN:
                Log.e(TGA,"notifyState :"+"WIFI_BLE_OPEN");
                deviceScan(communicationState, 5000);
                setTitle("BLE Scan");
                break;
            case WIFI_BLE_NONE_OPEN:
                Log.e(TGA, "notifyState :" + "WIFI_BLE_NONE_OPEN");
                setTitle("Disable");
                if(deviceScanPresenterCallBack != null){
                    deviceScanPresenterCallBack.wifi_ble_disable();
                }
                break;
        }
    }




    private void registerBroadcast(){
        IntentFilter filter = new IntentFilter();
        filter.addAction(WifiManager.WIFI_STATE_CHANGED_ACTION);
        filter.addAction(WifiManager.NETWORK_STATE_CHANGED_ACTION);
        filter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED);
        context.registerReceiver(mWifiReceiver, filter);
    }

    public void activityDestroy(){
        context.unregisterReceiver(mWifiReceiver);
    }

    public void deviceScan(int delayMillis){
        Log.e(".......", "deviceScan________________________________________");
        deviceScan(communicationManage.getCommunicationState_static(), delayMillis);
    }

    private void deviceScan(CommunicationState communicationState,int delayMillis){
        devices.clear();
        if(deviceScanPresenterCallBack != null){
            deviceScanPresenterCallBack.scan();
        }

        switch (communicationState){
            case BLE_OPEN_ONLY:
                Log.e("TGA", "deviceScan :" + "BLE_OPEN_ONLY");
                ble_scan(leScanCallback, delayMillis);
            case WIFI_BLE_OPEN:
                Log.e("TGA", "deviceScan :" + "WIFI_BLE_OPEN");
                ble_scan(leScanCallback, delayMillis);
                mdnsScan(delayMillis);
                break;
            case WIFI_OPEN_ONLY:
                Log.e("TGA","deviceScan :"+"WIFI_OPEN_ONLY");
                wifi_scan(delayMillis);
                mdnsScan(delayMillis);
            case WIFI_BLE_NONE_OPEN:
                Log.e("TGA", "notifyState :" + "WIFI_BLE_NONE_OPEN");
                break;
        }
    }

    BluetoothAdapter.LeScanCallback leScanCallback = new BluetoothAdapter.LeScanCallback() {
        @Override
        public void onLeScan(BluetoothDevice device, int rssi, byte[] scanRecord) {
            String serviceUUID = DuoBLEUtils.getService_UUID_from_scanRecord(scanRecord);
            boolean dest_services = false;
            Log.e("Scan callback",serviceUUID+"   "+device.getName());
            for (String u : bleServicesUUIDMask){
                if (serviceUUID.toUpperCase().equals(u.toUpperCase())){
                    dest_services = true;
                }
            }
            if(!dest_services){
                return;
            }

            boolean haveD = false;
            for (Device d : devices){
                if (d.getBleDevice() == null)
                    continue;
                if (d.getBleDevice().getAddress().equals(device.getAddress())){
                    haveD = true;
                }
            }
            if (!haveD){
                Device dTemp = new Device();
                dTemp.setConnectState(serviceUUID);
                dTemp.setBleDevice(device);
                devices.add(dTemp);
            }
        }
    };

    private void ble_scan(final BluetoothAdapter.LeScanCallback leScanCallback,long delayMillis){
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                ble.stop_scan(leScanCallback);
                if(deviceScanPresenterCallBack != null){
                    deviceScanPresenterCallBack.scanFinish(devices);
                }
            }
        }, delayMillis);
        ble.start_scan(leScanCallback);
    }

    private void wifi_scan(int delayMillis){
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                List<ScanResult> wifi_devices = DuoWifiUtils.wifi_stop_scan();
                for(ScanResult s : wifi_devices){
                    if(s.SSID.startsWith("Duo")){
                        devices.add(new Device(s));
                    }
                }
                if(deviceScanPresenterCallBack != null){
                    deviceScanPresenterCallBack.scanFinish(devices);
                }
                mdnsManage.stopServiceDiscovery();
            }
        }, delayMillis);
        DuoWifiUtils.wifi_start_scan();
    }


    private MDNSManage.OnMDNSDevicesScanCallback callback = new MDNSManage.OnMDNSDevicesScanCallback() {
        @Override
        public void onScanCallback(String name, String IP, int port) {
            Device d = new Device();
            d.port = port;
            d.IP = IP;
            d.name = name;
            d.setConnectStateController();
            devices.add(d);
        }
    };


    private void mdnsScan(int delayMillis){
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                mdnsManage.stopServiceDiscovery();
            }
        }, delayMillis);
        DuoWifiUtils.wifi_start_scan();
        mdnsManage.scanMDNSDevices(Common.MDNS_CONTROLLER_SERVICE_TYPE);
    }


    public void connectDevice(int position){
        if (devices.size() < position || devices.size() == 0)
            return;
        switch (devices.get(position).getConnectState()){
            case Common.CONNECT_STATE_DEFAULT:
                Log.e("CONNECT_STATE","CONNECT_STATE_DEFAULTj");
                break;
            case Common.CONNECT_STATE_PROVISION:
                Log.e("CONNECT_STATE","CONNECT_STATE_PROVISION");
                Intent intent = new Intent(context,ProvisionMainActivity.class);
                intent.putExtra(ProvisionMainActivity.getExtraBLEString(),devices.get(position).getBleDevice());
                intent.putExtra(ProvisionMainActivity.getExtraWifiString(),devices.get(position).getWifiDevice());
                context.startActivity(intent);
                break;
            case Common.CONNECT_STATE_CONTROLLER:
                Log.e("CONNECT_STATE","CONNECT_STATE_CONTROLLER");
                Intent intent2 = ControlActivity.getIntent(context,devices.get(position).name,
                                                                   devices.get(position).IP,
                                                                   devices.get(position).port,
                                                                   devices.get(position).getBleDevice());

                context.startActivity(intent2);
                break;
        }
    }

    public void setDeviceScanPresenterCallBack(DeviceScanPresenterCallBack deviceScanPresenterCallBack){
        this.deviceScanPresenterCallBack = deviceScanPresenterCallBack;
    }

    public void checkCommunicationState(){
        communicationManage.getCommunicationState();
    }

    public interface DeviceScanPresenterCallBack{
        void scanFinish(ArrayList<Device> devices);
        void scan();
        void wifi_ble_disable();
    }

    private BroadcastReceiver mWifiReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent != null) {
                if (WifiManager.WIFI_STATE_CHANGED_ACTION.equals(intent.getAction())) {
                    int wifiState = intent.getIntExtra(WifiManager.EXTRA_WIFI_STATE, 0);
                    switch (wifiState) {
                        case WifiManager.WIFI_STATE_DISABLED:
                            log("wifiState WIFI_STATE_DISABLED");
                           // MApplication.getMApplication().duoTaskObservable.nextTask(Step.WIFI_NOT_ON);
                            //MApplication.IS_WIFI_OPEN = false;
                            notifyCommunicationState();
                            break;
                        case WifiManager.WIFI_STATE_ENABLED:
                            log("wifiState WIFI_STATE_ENABLED");
                            //MApplication.getMApplication().duoTaskObservable.nextTask(Step.WIFI_ON);
                            //MApplication.IS_WIFI_OPEN = true;
                            notifyCommunicationState();
                            break;
                    }
                }
                if (WifiManager.NETWORK_STATE_CHANGED_ACTION.equals(intent.getAction())) {
                    NetworkInfo info = intent.getParcelableExtra(WifiManager.EXTRA_NETWORK_INFO);
                    if(info.getState().equals(NetworkInfo.State.DISCONNECTED)){
                    }
                    if(info.getState().equals(NetworkInfo.State.CONNECTED)){
                        new Handler().postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                Log.e(".......", "NETWORK_STATE_CHANGED_ACTION________________________________________");
                                //checkAP_is_WifiProvision();
                            }
                        },1000);
                    }
                }

                if (BluetoothAdapter.ACTION_STATE_CHANGED.equals(intent.getAction())) {
                    int bleState = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, 0);
                    switch (bleState) {
                        case BluetoothAdapter.STATE_OFF:
                            log("ble STATE_OFF");
//                            MApplication.IS_BLE_OPEN = false;
                            notifyCommunicationState();
                            break;
                        case BluetoothAdapter.STATE_ON:
                            log("ble STATE_ON");
//                            MApplication.IS_BLE_OPEN = true;
//                            MApplication.getMApplication().doNext = MApplication.BLE_SCAN;
                            notifyCommunicationState();
                            break;
                    }
                }
            }
        }
    };

    private void dialogToShow(String message){
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setTitle("Warning");
        builder.setMessage(message);
        builder.setIcon(R.mipmap.ic_launcher);
        builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                context.finish();
            }
        });
        builder.create().show();
    }

    private void addStep(Step step){
        MApplication.getMApplication().duoTaskObservable.addTask(step);
    }

    private void log(String s){
        Log.e(TGA, s);
    }
}
