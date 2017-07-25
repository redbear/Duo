package net.redbear.redbearduo.data.communication.ble;


import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattDescriptor;
import android.bluetooth.BluetoothGattService;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothProfile;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.util.Log;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.UUID;



public class DuoBLE {

	String TAG = DuoBLE.class.getSimpleName();
	private Context context;
	private BluetoothManager bluetoothManager;
	private BluetoothAdapter bluetoothAdapter;
	private BluetoothGatt bluetoothGatt;

    //scan
	private ArrayList<BluetoothDevice> device_list;
	final int SCANTIME = 5000;
	boolean scanflag;


	public DuoBLE(Context context) {
		// TODO Auto-generated constructor stub
        if (context != null){
            this.context = context;
        }
		ble_init();
	}

	public static void ble_open(Activity activity) {
		BluetoothAdapter bluetoothAdapter;
        //check BLE is supported on net.redbear.redbearduo.data.device or not
        if(! activity.getPackageManager().hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)) {
        	activity.finish();
        }
        final BluetoothManager bluetoothManager = (BluetoothManager) activity.getSystemService(Context.BLUETOOTH_SERVICE);
        bluetoothAdapter = bluetoothManager.getAdapter();
        
        if(bluetoothAdapter == null) {
        	activity.finish();
        }
      //to determine whether BLE is open,if not then open by using android API
        if(! bluetoothAdapter.isEnabled()) {
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            activity.startActivityForResult(enableBtIntent,100);
        }
	}

	public boolean ble_init() {
		if (bluetoothManager == null) {
			bluetoothManager = (BluetoothManager) context.getSystemService(context.BLUETOOTH_SERVICE);
			if(bluetoothManager == null) {
				Log.e(TAG, "Unable to initialize BluetoothManager.");
				return false;
			}
		}
		
		bluetoothAdapter = bluetoothManager.getAdapter();
		if(bluetoothAdapter == null) {
            Log.e(TAG, "Unable to obtain a BluetoothAdapter.");
            return false;
		}
		return true;
	}


	public ArrayList<BluetoothDevice> ble_scan_nocb() {

		device_list = new ArrayList<>();
		Handler handler = new Handler();
	    scanflag = false;

		final BluetoothAdapter.LeScanCallback scanCallback =new BluetoothAdapter.LeScanCallback() {

			@Override
			public void onLeScan(BluetoothDevice device, int rssi, byte[] scanRecord) {
				// TODO Auto-generated method stub
				device_list.add(device);
			}
		};

		if(bluetoothAdapter == null) {
			Log.e(TAG, "None BluetoothAdapter.");
			return null;
		}

		handler.postDelayed(new Runnable() {

			@Override
			public void run() {
				// TODO Auto-generated method stub
				bluetoothAdapter.stopLeScan(scanCallback);
				Log.e(TAG, device_list.toString());
				scanflag =true;
			}
		}, SCANTIME);
		bluetoothAdapter.startLeScan(scanCallback);
        Log.e(TAG, "start scan");

        if(scanflag == true) {
        	scanflag = false;
        }
     	return device_list;
	}
	
	public void start_scan(BluetoothAdapter.LeScanCallback scanCallback) {
		if(bluetoothAdapter == null) {
			Log.e(TAG, "None BluetoothAdapter.");
			return;
		}
		Log.e(TAG, "start_scan");
		bluetoothAdapter.startLeScan(scanCallback);
	}
	
	public void stop_scan(BluetoothAdapter.LeScanCallback scanCallback) {
		if(bluetoothAdapter == null) {
			Log.e(TAG, "None BluetoothAdapter.");
			return;
		}
		Log.e(TAG, "stop_scan");
		bluetoothAdapter.stopLeScan(scanCallback);
	}


	public void ble_colse() {
	    if (bluetoothGatt== null) {
	        return;
	    }
	    bluetoothGatt.close();
	    bluetoothGatt = null;
	}
}
