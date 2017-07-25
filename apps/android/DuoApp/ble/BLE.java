package net.redbear.redbearduo.data.communication.ble;

import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattDescriptor;
import android.bluetooth.BluetoothGattService;
import android.bluetooth.BluetoothProfile;
import android.content.Context;
import android.os.Handler;

import java.util.UUID;

/**
 * Created by Dong on 15/12/28.
 */
public class BLE {
    private Context context;
    private BluetoothGatt bluetoothGatt;

    private BluetoothGattCharacteristic commandCharacteristic;
    private BluetoothGattCharacteristic stateCharacteristic;

    private BluetoothDevice bluetoothDevice;


    private BLECallback bleCallback;
    private boolean initFlg;


    public BLE(Context context,BluetoothDevice bluetoothDevice){
        this.bluetoothDevice = bluetoothDevice;
        this.context = context;
    }

    public void connect () {
        bluetoothGatt = bluetoothDevice.connectGatt(context, false, bluetoothGattCallback);
    }


    BluetoothGattCallback bluetoothGattCallback = new BluetoothGattCallback() {
        @Override
        public void onConnectionStateChange(BluetoothGatt gatt, int status, int newState) {
            super.onConnectionStateChange(gatt, status, newState);
            if(newState == BluetoothProfile.STATE_CONNECTED) {
                bluetoothGatt.discoverServices();
            }
            if(newState == BluetoothProfile.STATE_DISCONNECTED) {
            }
        }

        @Override
        public void onServicesDiscovered(BluetoothGatt gatt, int status) {
            super.onServicesDiscovered(gatt, status);
            if(status == BluetoothGatt.GATT_SUCCESS ) {
                for (BluetoothGattService temp : bluetoothGatt.getServices()) {
                    if(temp.getUuid().toString().equals(BLEUtils.DuoProvisionServiceUUID)) {
                        commandCharacteristic = temp.getCharacteristic(UUID.fromString(BLEUtils.CommandUUID));
                        stateCharacteristic = temp.getCharacteristic(UUID.fromString(BLEUtils.StateUUID));

                        if (commandCharacteristic.getProperties() == BluetoothGattCharacteristic.PROPERTY_NOTIFY){
                            bluetoothGatt.setCharacteristicNotification(commandCharacteristic,true);
                            BluetoothGattDescriptor descriptor = commandCharacteristic.getDescriptor(UUID.fromString("00002902-0000-1000-8000-00805f9b34fb"));
                            descriptor.setValue(BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE);
                            bluetoothGatt.writeDescriptor(descriptor);
                        }

                        new Handler().postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                if (stateCharacteristic.getProperties() == BluetoothGattCharacteristic.PROPERTY_NOTIFY) {
                                    bluetoothGatt.setCharacteristicNotification(stateCharacteristic, true);
                                    BluetoothGattDescriptor descriptor = stateCharacteristic.getDescriptor(UUID.fromString("00002902-0000-1000-8000-00805f9b34fb"));
                                    descriptor.setValue(BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE);
                                    bluetoothGatt.writeDescriptor(descriptor);
                                }
                            }
                        }, 1000);
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
        }

        @Override
        public void onDescriptorRead(BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status) {
            super.onDescriptorRead(gatt, descriptor, status);
        }

        @Override
        public void onDescriptorWrite(BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status) {
            super.onDescriptorWrite(gatt, descriptor, status);
            if (descriptor.getCharacteristic().getUuid().toString().toUpperCase().equals(BLEUtils.StateUUID) && initFlg == false){
                initFlg = true;
                if (bleCallback != null){
                    bleCallback.onInitFinish();
                }
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


    public void setBleCallback(BLECallback bleCallback) {
        this.bleCallback = bleCallback;
    }

    public interface BLECallback{
        void onInitFinish();
    }

}
