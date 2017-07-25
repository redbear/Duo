package net.redbear.redbearduo.view.Activity;

import android.app.Application;
import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import com.crashlytics.android.Crashlytics;
import io.fabric.sdk.android.Fabric;
import net.redbear.taskmap.DuoTaskObservable;
import net.redbear.taskmap.duoTask.BleController;
import net.redbear.taskmap.duoTask.BleProvision;
import net.redbear.taskmap.duoTask.WifiController;
import net.redbear.taskmap.duoTask.WifiProvision;

/**
 * Created by Dong on 15/10/13.
 */
public class MApplication extends Application {

    public static final String appname = "net.redbear.redbearduo";
    public static final String sharePreferences_app_first_run = "net.redbear.redbearduo.SharePreferencesData";
    public static final String sharePreferences_duo_firmware_version = "net.redbear.redbearduo.sharePreferences.duo.firmware.version";
    public static final String sharePreferences_duo_firmware_size = "net.redbear.redbearduo.sharePreferences.duo.firmware.size";
    //public static String FIRMWARE_VERSION;
    public static final int BLE_SCAN = 0;
    public static final int WIFI_PROVISION = 1;
    public static final int WIFI_CONTROLLER = 2;
    public static final int CONNECT_STATE_NONE = 0;
    public static final int CONNECT_STATE_BLE_ONLY = 1;
    public static final int CONNECT_STATE_WIFI_ONLY = 2;
    public static final int CONNECT_STATE_BLE_WIFI = 3;

    private static MApplication ourInstance;

    public static boolean haveNewVersionFLG;


    public static boolean FIRST_RUN_STATE = false;
    public static boolean IS_BLE_OPEN = false;
    public static boolean IS_WIFI_OPEN = false;
    public static int doNext = BLE_SCAN;

    public DuoTaskObservable duoTaskObservable;
    public BleController bleControllerTask;
    public BleProvision bleProvisionTask;
    public WifiController wifiControllerTask;
    public WifiProvision wifiProvisionTask;


    public static MApplication getMApplication() {
        synchronized (DuoTaskObservable.class){
            if (ourInstance == null){
                ourInstance = new MApplication();
            }
        }
        return ourInstance;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        Fabric.with(this, new Crashlytics());
        ourInstance = this;
        duoTaskObservable = DuoTaskObservable.getInstance();
        bleControllerTask = new BleController();
        duoTaskObservable.registerObserver(bleControllerTask);
        bleProvisionTask = new BleProvision();
        duoTaskObservable.registerObserver(bleProvisionTask);
        wifiControllerTask = new WifiController();
        duoTaskObservable.registerObserver(wifiControllerTask);
        wifiProvisionTask = new WifiProvision();
        duoTaskObservable.registerObserver(wifiProvisionTask);
    }


    public static int getConnectState(){
        if (IS_BLE_OPEN && !IS_WIFI_OPEN){
            Log.e("getConnectState", "11111");
            return CONNECT_STATE_BLE_ONLY;
        }
        if (!IS_BLE_OPEN && IS_WIFI_OPEN){
            Log.e("getConnectState","2222");
            return CONNECT_STATE_WIFI_ONLY;
        }
        if (IS_BLE_OPEN && IS_WIFI_OPEN){
            Log.e("getConnectState","3333");
            return CONNECT_STATE_BLE_WIFI;
        }
        return CONNECT_STATE_NONE;
    }



    public static boolean getSharePreferencesData(String filename,String arg) {
        SharedPreferences read = MApplication.getMApplication().getSharedPreferences(filename, Context.MODE_PRIVATE);
        return read.getBoolean(arg,false);
    }

    public static String getSharePreferencesVersionStringData(String filename, String arg) {
        SharedPreferences read = MApplication.getMApplication().getSharedPreferences(filename, Context.MODE_PRIVATE);
        return read.getString(arg, "0.0.0");
    }
    public static int getSharePreferencesVersionIntData(String filename, String arg) {
        SharedPreferences read = MApplication.getMApplication().getSharedPreferences(filename, Context.MODE_PRIVATE);
        return read.getInt(arg, 0);
    }

    public static void setSharePreferencesData(String filename, String arg, String data) {
        SharedPreferences.Editor editor = MApplication.getMApplication().getSharedPreferences(filename, Context.MODE_PRIVATE).edit();
        editor.putString(arg, data);
        editor.commit();
    }
    public static void setSharePreferencesData(String filename, String arg, int data) {
        SharedPreferences.Editor editor = MApplication.getMApplication().getSharedPreferences(filename, Context.MODE_PRIVATE).edit();
        editor.putInt(arg, data);
        editor.commit();
    }
}
