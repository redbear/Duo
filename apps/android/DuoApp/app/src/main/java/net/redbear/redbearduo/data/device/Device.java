package net.redbear.redbearduo.data.device;

import android.bluetooth.BluetoothDevice;
import android.net.wifi.ScanResult;

import net.redbear.redbearduo.data.Common;

/**
 * Created by Dong on 16/1/4.
 */
public class Device {
    private int connectState = Common.CONNECT_STATE_DEFAULT;
    private BluetoothDevice bleDevice;
    private ScanResult wifiDevice;


    public String name;
    public String macAddress;
    public String IP;
    public int port;

    public Device(){}
    public Device(ScanResult wifiDevice){
        setWifiDevice(wifiDevice);
        connectState = Common.CONNECT_STATE_PROVISION;
    }

    public int getConnectState() {
        return connectState;
    }

    public void setConnectState(String ble_service_UUID){
        if (ble_service_UUID.toUpperCase().equals(Common.PROVISION_UUID.toUpperCase())){
            connectState = Common.CONNECT_STATE_PROVISION;
        }
        if (ble_service_UUID.toUpperCase().equals(Common.CONTROLLER_UUID.toUpperCase())){
            connectState = Common.CONNECT_STATE_CONTROLLER;
        }
    }
    public void setConnectStateController(){
        connectState = Common.CONNECT_STATE_CONTROLLER;
    }


    public BluetoothDevice getBleDevice() {
        return bleDevice;
    }

    public void setBleDevice(BluetoothDevice device) {
        this.bleDevice = device;
        name = bleDevice.getName();
        macAddress = bleDevice.getAddress();
    }

    public ScanResult getWifiDevice() {
        return wifiDevice;
    }

    public void setWifiDevice(ScanResult wifiDevice) {
        this.wifiDevice = wifiDevice;
        name = wifiDevice.SSID;
        macAddress = "FF:FF:FF:FF:FF:FF";
    }

    public void setControlDevice(String name,String IP,int port){
        this.name = name;
        this.IP = IP;
        this.port = port;
        macAddress = "FF:FF:FF:FF:FF:FF";
    }
}
