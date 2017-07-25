package net.redbear.module.communicate.ble;

import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattDescriptor;
import android.bluetooth.BluetoothGattService;
import android.bluetooth.BluetoothProfile;
import android.content.Context;
import android.os.Handler;
import android.util.Log;

import java.lang.reflect.Method;
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;

import net.redbear.module.communicate.AP;
import net.redbear.module.communicate.CanCommunicate;
import net.redbear.module.communicate.CommunicateCallBack;
import net.redbear.module.communicate.DuoInfo;
import net.redbear.module.communicate.DuoIPInfo;

import static net.redbear.module.communicate.ble.BLEUtils.*;

/**
 * Created by Dong on 15/12/28.
 */
public class BLE implements CanCommunicate,BLEDataReceive.BleDataReceiveCallBack{
    private Context context;
    private BluetoothGatt bluetoothGatt;
    private BluetoothGattCharacteristic commandCharacteristic;
    private BluetoothGattCharacteristic stateCharacteristic;
    private BluetoothDevice bluetoothDevice;
    private int delayTime;
    private boolean connectTimeoutFlg;

    private int step;
    private BLEDataReceive bleDataReceive;

    private CommunicateCallBack communicateCallBack;

    public BLE(Context context,BluetoothDevice bluetoothDevice){
        this.bluetoothDevice = bluetoothDevice;
        this.context = context;
        bleDataReceive = new BLEDataReceive(this);
    }

    BluetoothGattCallback bluetoothGattCallback = new BluetoothGattCallback() {
        @Override
        public void onConnectionStateChange(BluetoothGatt gatt, int status, int newState) {
            super.onConnectionStateChange(gatt, status, newState);
            if(newState == BluetoothProfile.STATE_CONNECTED) {
                bluetoothGatt.discoverServices();
            }
            if(newState == BluetoothProfile.STATE_DISCONNECTED) {
                if (communicateCallBack == null)
                    return;
                Log.e("ble provision","BluetoothProfile.STATE_DISCONNECTED ...");
                communicateCallBack.onDisconnectFromDuo("BLE Disconnect");
            }
        }

        @Override
        public void onServicesDiscovered(BluetoothGatt gatt, int status) {
            super.onServicesDiscovered(gatt, status);
            if(status == BluetoothGatt.GATT_SUCCESS ) {
                for (BluetoothGattService temp : bluetoothGatt.getServices()) {
                    Log.e("BluetoothGattService","uuid   :"+temp.getUuid().toString());
                    if(temp.getUuid().toString().toUpperCase().equals(BLEUtils.DuoProvisionServiceUUID)) {
                        commandCharacteristic = temp.getCharacteristic(UUID.fromString(BLEUtils.CommandUUID));
                        Log.e("BluetoothGattService","commandCharacteristic   :"+commandCharacteristic.getProperties());
                        stateCharacteristic = temp.getCharacteristic(UUID.fromString(BLEUtils.StateUUID));
                        Log.e("BluetoothGattService","stateCharacteristic   :"+stateCharacteristic.getProperties());
                        setNotification(commandCharacteristic);
                        setNotification(stateCharacteristic);
                    }
                }
            }
        }

        @Override
        public void onCharacteristicRead(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status) {
            super.onCharacteristicRead(gatt, characteristic, status);
        }

        @Override
        public void onCharacteristicWrite(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status) {
            super.onCharacteristicWrite(gatt, characteristic, status);
        }

        @Override
        public void onCharacteristicChanged(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic) {
            super.onCharacteristicChanged(gatt, characteristic);
        //    Log.e("DIYBluetoothGattback",  "onCharacteristicChanged");
            byte[] dataByte = characteristic.getValue();
            int[] data = new int[dataByte.length];
            for (int i=0;i<data.length;i++){
                data[i] = (dataByte[i]<0)?(256+dataByte[i]):dataByte[i];
            }

            try{
                if (characteristic.getUuid().toString().toUpperCase().equals(BLEUtils.CommandUUID)){
                    for (int i = 0;i<characteristic.getValue().length;i++){
                        Log.e("date  CommandUUID",  i+"   "+data[i]);
                    }
                    bleDataReceive.receive(data);
                }
                if (characteristic.getUuid().toString().toUpperCase().equals(BLEUtils.StateUUID)){
                    for (int i = 0;i<characteristic.getValue().length;i++){
                        Log.e("date state CommandUUID",  i+"   "+data[i]);
                    }
                    onStateCharacteristicDataNotify(data);
                }
            }catch (BleDataReceiveException b){
                //receive net.redbear.redbearduo.data error
                Log.e("error","________"+b+"_________");
            }

        }

        @Override
        public void onDescriptorRead(BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status) {
            super.onDescriptorRead(gatt, descriptor, status);
        }

        @Override
        public void onDescriptorWrite(BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status) {
            super.onDescriptorWrite(gatt, descriptor, status);
            if (descriptor.getCharacteristic().getUuid().toString().toUpperCase().equals(BLEUtils.StateUUID)){
                if (communicateCallBack!= null){
                    communicateCallBack.onConnectToDuo();
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            Log.e("....","get version22222");
                            try {
                                Thread.sleep(1000);
                            } catch (InterruptedException e) {
                                e.printStackTrace();
                            }
                            getVersion();
                        }
                    }).start();
                }
            }
            Log.e("getDescriptor", "descriptor" + bluetoothGatt.readDescriptor(descriptor));
        }

        @Override
        public void onReliableWriteCompleted(BluetoothGatt gatt, int status) {
            super.onReliableWriteCompleted(gatt, status);
        }

        @Override
        public void onReadRemoteRssi(BluetoothGatt gatt, int rssi, int status) {
            super.onReadRemoteRssi(gatt, rssi, status);
        }

        @Override
        public void onMtuChanged(BluetoothGatt gatt, int mtu, int status) {
            super.onMtuChanged(gatt, mtu, status);
        }
    };

    private void setNotification(final BluetoothGattCharacteristic bluetoothGattCharacteristic){
        new Timer().schedule(new TimerTask() {
            @Override
            public void run() {
                bluetoothGattCharacteristic.setWriteType(BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT);
                Log.e("init", "setNotification :" + bluetoothGattCharacteristic.getUuid().toString());
                bluetoothGatt.setCharacteristicNotification(bluetoothGattCharacteristic, true);
                BluetoothGattDescriptor descriptor = bluetoothGattCharacteristic.getDescriptor(UUID.fromString("00002902-0000-1000-8000-00805f9b34fb"));

                Log.e("init", "bluetoothGattCharacteristic.getService().getType() :" + bluetoothGattCharacteristic.getService().getType());

                descriptor.setValue(BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE);
                bluetoothGatt.writeDescriptor(descriptor);


            }
        },delayTime);
        delayTime +=2000;
    }

    private void onStateCharacteristicDataNotify(int[] data){
        if (communicateCallBack == null)
            return;
        switch (data[0]){
            case BLEUtils.DUO_STATE_SCANNING:
                communicateCallBack.onScanning();
                break;
            case BLEUtils.DUO_STATE_SCAN_COMPLETE:
                communicateCallBack.onScanComplete(null);
                break;
            case BLEUtils.DUO_STATE_CONNECTING:
                communicateCallBack.onConnecting();
                break;
            case BLEUtils.DUO_STATE_CONFIG_AP:
                Log.e("communicateCallBack","DUO_STATE_CONFIG_AP");
                connectAP();
                break;
            case BLEUtils.DUO_STATE_CONNECT_FAILED:
                communicateCallBack.onBoardConnectToAPError(null);
                break;
            case BLEUtils.DUO_STATE_CONNECT_COMPLETE:
                //communicateCallBack.onConnectComplete();
                break;
        }
    }

    @Override
    public void connect () {
        bluetoothGatt = bluetoothDevice.connectGatt(context, false, bluetoothGattCallback);
        refreshDeviceCache(bluetoothGatt);
        setConnectTimeout(10000);
    }

    private void setConnectTimeout(int time){
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                if (!connectTimeoutFlg){
                    if (communicateCallBack == null)
                        return;
                    communicateCallBack.onConnectTimeout();
                }
            }
        },time);
    }

    @Override
    public void getVersion() {
        step = CanCommunicate.STEP_GET_SYSTEM_INFO;
        writeData(commandCharacteristic,getDataByCMD(BLE_PROVISION_COMMAND_GET_SYS_INFO),0);
    }

    @Override
    public void OTAFile(String version) {

    }

    @Override
    public void scan() {
        step = CanCommunicate.STEP_SCAN;
        writeData(commandCharacteristic, getDataByCMD(BLE_PROVISION_COMMAND_SCAN), 0);
    }

    @Override
    public void sendPassword(AP ap,String password) {
        writeData(commandCharacteristic, getPasswordData(ap, password),200);
    }

    public void connectAP() {
        writeData(commandCharacteristic, getDataByCMD(BLE_PROVISION_COMMAND_CONNECT_AP), 0);
    }

    private byte[] getPasswordData(AP ap,String password){
        Log.e("sendPassword", " " + ap.toString());
        byte[] data = new byte[9+password.length()+ap.getSsid().length()];
        Log.e("sendPassword", "dataLen " + data.length);

        data[0] = (byte)data.length;
        data[1] = (byte)BLE_PROVISION_COMMAND_CONFIG_AP;
        data[2] = (byte)((int)ap.getChannel());
        //security
        data[3] = (byte)(ap.getSecurity()%256);
        data[4] = (byte)((ap.getSecurity()/256)%256);
        data[5] = (byte)((ap.getSecurity()/65536)%256);
        data[6] = (byte)(ap.getSecurity()/16777216);

        data[7] = (byte)ap.getSsid().length();
        char[] ssidData = ap.getSsid().toCharArray();
        for (int j =0;j<data[7];j++){
            data[j+8] = (byte)ssidData[j];
        }

        data[8+data[7]] = (byte)password.length();
        char[] passwordData = password.toCharArray();
        for (int j =0;j<data[8+data[7]];j++){
            data[j+8+data[7]+1] = (byte)passwordData[j];
        }
        return data;
    }

    @Override
    public void setCommunicateCallBack(CommunicateCallBack communicateCallBack) {
        this.communicateCallBack = communicateCallBack;
    }

    @Override
    public void disconnect() {
        if (bluetoothGatt == null)
            return;
        bluetoothGatt.disconnect();
        bluetoothGatt.close();
        bluetoothGatt = null;
    }

    @Override
    public void checkDeviceHaveWifiProfile() {

    }

    private void writeData(final BluetoothGattCharacteristic bluetoothGattCharacteristics, final byte[] data, final int delayTime){
        Log.e("writeDataOnePackage",  "nnnnnnnnnnnnn"+"111   "+"net.redbear.redbearduo.data.length  "+data.length);
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    int packageLen = data.length/20 + 1;
                    Log.e("writeDataOnePackage",  "nnnnnnnnnnnnn"+"222   "+"packageLen  "+packageLen);
                    for (int i = 0 ;i < packageLen;i ++){
                        writeDataOnePackage(bluetoothGattCharacteristics,get20ByteData(data,i),delayTime);
                    }
                }catch (Exception e){

                }
            }
        }).start();
    }

    private byte[] get20ByteData(byte[] data,int witch){
        byte[] dataReturn = null;
        if ((witch+1)*20 > data.length){
            dataReturn = new byte[data.length%20];
        }else {
            dataReturn = new byte[20];
        }
        for (int i =0;i<dataReturn.length;i++){
            dataReturn[i] = data[20*witch+i];
        }
        return dataReturn;
    }

    private void writeDataOnePackage(final BluetoothGattCharacteristic bluetoothGattCharacteristics, final byte[] data, final int delayTime) throws InterruptedException {
        bluetoothGattCharacteristics.setWriteType(BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE);
        Log.e("writeDataOnePackage",  "nnnnnnnnnnnnn"+"333   "+"net.redbear.redbearduo.data.length  "+data.length);
        for (int i = 0;i<data.length;i++){
            Log.e("send",  i+"   "+data[i]);
        }

        if (bluetoothGattCharacteristics != null) {
            if (bluetoothGattCharacteristics.setValue(data)) {
                if (!bluetoothGatt.writeCharacteristic(bluetoothGattCharacteristics)) {
                    Log.e("BLE", "Error: writeCharacteristic!");
                }
            }
        }
        Thread.sleep(delayTime);
    }

    @Override
    public void onAPCallBack(AP ap) {
        if (communicateCallBack == null)
            return;
        communicateCallBack.onScanAnAP(ap);
    }

    @Override
    public void onDuoInfoCallBack(DuoInfo duoInfo) {
        Log.e("onDuoInfoCallBack",duoInfo.toString());
        connectTimeoutFlg = true;
        if (communicateCallBack == null)
            return;
        communicateCallBack.onGetFirmVersion(duoInfo.getReleaseVersion());
    }

    @Override
    public void onDuoIPInfoCallBack(DuoIPInfo duoIPInfo) {
        communicateCallBack.onConnectComplete(duoIPInfo);
    }

    private boolean refreshDeviceCache(BluetoothGatt gatt){
        try {
            BluetoothGatt localBluetoothGatt = gatt;
            Method localMethod = localBluetoothGatt.getClass().getMethod("refresh", new Class[0]);
            if (localMethod != null) {
                boolean bool = ((Boolean) localMethod.invoke(localBluetoothGatt, new Object[0])).booleanValue();
                return bool;
            }
        }
        catch (Exception localException) {
            Log.e("TAG", "An exception occur while refreshing device");
        }
        return false;
    }
}
