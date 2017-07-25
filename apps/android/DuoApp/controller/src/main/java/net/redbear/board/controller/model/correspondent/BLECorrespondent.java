package net.redbear.board.controller.model.correspondent;

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

import net.redbear.board.controller.model.product.Common;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;

/**
 * Created by dong on 3/22/16.
 */
public class BLECorrespondent implements Correspondent {

    private Context context;
    private BluetoothDevice bluetoothDevice;
    private BluetoothGatt bluetoothGatt;

    private BluetoothGattCharacteristic commandCharacteristic;
    private BluetoothGattCharacteristic notifyCharacteristic;

    private boolean connectFlg;
    private int notifyDelayTime;


    private CorrespondentDataCallback callback;


    public BLECorrespondent(Context context, BluetoothDevice bluetoothDevice){
        this.bluetoothDevice = bluetoothDevice;
        this.context = context;
    }


    @Override
    public void connect() {
        bluetoothGatt = bluetoothDevice.connectGatt(context, false, bluetoothGattCallback);
        refreshDeviceCache(bluetoothGatt);
        setConnectTimeout(10000);
    }

    private void setConnectTimeout(int time){
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                if (!connectFlg){
                    if (callback != null)
                        callback.onConnectFail();
                }
            }
        },time);
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
    public void setPinMode(int pin, int pinMode) {
        sendData(new byte[]{'S',(byte)pin,(byte)pinMode});
    }

    @Override
    public void getPinValue(int pin) {

    }

    @Override
    public void setPinData(int pin, int pinMode, int data) {
        byte[] d = new byte[3];
        switch (pinMode){
            case Common.DUO_PIN_MODE_DIGITAL_WRITE:
                d[0] = 'T';
                break;
            case Common.DUO_PIN_MODE_PWM:
                d[0] = 'N';
                break;
            case Common.DUO_PIN_MODE_SERVO:
                d[0] = 'O';
                break;

        }
        d[1] = (byte) pin;
        d[2] = (byte) data;
        sendData(d);
    }

    @Override
    public void resetAll() {
        sendData(new byte[]{'R'});
    }

    @Override
    public void setCorrespondentDataCallback(CorrespondentDataCallback callback) {
        this.callback = callback;
    }

    BluetoothGattCallback bluetoothGattCallback = new BluetoothGattCallback() {
        @Override
        public void onConnectionStateChange(BluetoothGatt gatt, int status, int newState) {
            super.onConnectionStateChange(gatt, status, newState);
            if(newState == BluetoothProfile.STATE_CONNECTED) {
                bluetoothGatt.discoverServices();
            }
            if(newState == BluetoothProfile.STATE_DISCONNECTED) {
                Log.e("ble provision","BluetoothProfile.STATE_DISCONNECTED ...");
                if (callback != null)
                    callback.onDisconnect();
            }
        }

        @Override
        public void onServicesDiscovered(BluetoothGatt gatt, int status) {
            super.onServicesDiscovered(gatt, status);
            if(status == BluetoothGatt.GATT_SUCCESS ) {
                for (BluetoothGattService temp : bluetoothGatt.getServices()) {
                    Log.e("BluetoothGattService","uuid   :"+temp.getUuid().toString());
                    if(temp.getUuid().toString().toUpperCase().equals(Common.BLE_CONTROLLER_SERVICE_UUID)) {
                        commandCharacteristic = temp.getCharacteristic(UUID.fromString(Common.BLE_CONTROLLER_COMMAND_UUID));
                        notifyCharacteristic = temp.getCharacteristic(UUID.fromString(Common.BLE_CONTROLLER_NOTIFY_UUID));
                        setNotification(commandCharacteristic);
                        setNotification(notifyCharacteristic);
                    }
                }
            }
        }



        private void setNotification(final BluetoothGattCharacteristic bluetoothGattCharacteristic){
            new Timer().schedule(new TimerTask() {
                @Override
                public void run() {
                    bluetoothGattCharacteristic.setWriteType(BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT);
                    Log.e("init", "setNotification :" + bluetoothGattCharacteristic.getUuid().toString());
                    bluetoothGatt.setCharacteristicNotification(bluetoothGattCharacteristic, true);
                    BluetoothGattDescriptor descriptor = bluetoothGattCharacteristic.getDescriptor(UUID.fromString("00002902-0000-1000-8000-00805f9b34fb"));
                    descriptor.setValue(BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE);
                    bluetoothGatt.writeDescriptor(descriptor);
                }
            },notifyDelayTime);
            notifyDelayTime +=2000;
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
            byte[] data = characteristic.getValue();
            int[] intData = new int[data.length];
            for (int i =0;i<data.length;i++){
                if (data[i] < 0){
                    intData[i] =data[i]+256;
                }else {
                    intData[i] =data[i];
                }
            }
            Log.e("ble","receive   "+Arrays.toString(intData));
            if (data != null){
                if (callback != null ){
                    if (data.length == 5){
                        callback.onDataReceive(new DataPackage.Builder().setCommand(""+(char)intData[0]).setPin(intData[1]).setPinMode(intData[2]).setData(intData[3]*256+intData[4]).build());
                    }
                    else if (data.length == 1){
                        callback.onDataReceive(new DataPackage.Builder().setCommand(""+(char)intData[0]).build());
                    }
                    else {
                        callback.onDataReceive(new DataPackage.Builder().setCommand(""+(char)intData[0]).setPin(intData[1]).setPinMode(intData[2]).setData(intData[3]).build());
                    }
                }
            }

        }

        @Override
        public void onDescriptorRead(BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status) {
            super.onDescriptorRead(gatt, descriptor, status);
        }

        @Override
        public void onDescriptorWrite(BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status) {
            super.onDescriptorWrite(gatt, descriptor, status);
            if (descriptor.getCharacteristic().getUuid().toString().toUpperCase().equals(Common.BLE_CONTROLLER_NOTIFY_UUID)){
                connectFlg = true;
                if (callback != null)
                    callback.onConnectSuccess(true);
            }

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

    private void sendData(final byte[] data){
        Log.e("ble send data",Arrays.toString(data));
        commandCharacteristic.setWriteType(BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE);
        if (commandCharacteristic != null) {
            if (commandCharacteristic.setValue(data)) {
                if (!bluetoothGatt.writeCharacteristic(commandCharacteristic)) {
                    Log.e("BLE", "Error: writeCharacteristic!");
                }
            }
        }
    }


}
