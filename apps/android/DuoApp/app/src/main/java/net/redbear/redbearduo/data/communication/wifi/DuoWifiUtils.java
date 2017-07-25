package net.redbear.redbearduo.data.communication.wifi;

import android.content.Context;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiManager;

import net.redbear.redbearduo.view.Activity.MApplication;

import java.util.List;

/**
 * Created by Dong on 15/12/29.
 */
public class DuoWifiUtils {

    static public boolean wifi_check_support() {
        //check BLE is supported on net.redbear.redbearduo.data.device or not
        if(! MApplication.getMApplication().getPackageManager().hasSystemFeature(PackageManager.FEATURE_WIFI)) {
            return false;
        }
        return true;
    }

    static public void wifi_open() {
        WifiManager wifiManager = (WifiManager) MApplication.getMApplication().getSystemService(Context.WIFI_SERVICE);
        if(wifiManager == null) {
            return;
        }
        if (wifiManager.getWifiState() != WifiManager.WIFI_STATE_ENABLED){
            ((WifiManager) MApplication.getMApplication().getSystemService(Context.WIFI_SERVICE)).setWifiEnabled(true);
        }
    }

    static public boolean wifi_is_on() {
        WifiManager wifiManager = (WifiManager) MApplication.getMApplication().getSystemService(Context.WIFI_SERVICE);
        if(wifiManager == null) {
            return false;
        }
        return wifiManager.getWifiState() == WifiManager.WIFI_STATE_ENABLED;
    }
    static public boolean network_is_on() {
        ConnectivityManager mConnectivityManager = (ConnectivityManager) MApplication.getMApplication()
                .getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo mNetworkInfo = mConnectivityManager.getActiveNetworkInfo();
        if (mNetworkInfo != null && mNetworkInfo.isAvailable()) {
            return true;
        }
        return false;
    }

    static public String get_phone_connected_ap_ssid() {
        WifiManager wifiManager = (WifiManager) MApplication.getMApplication().getSystemService(Context.WIFI_SERVICE);
        return wifiManager.getConnectionInfo().getSSID();
    }

    static public void wifi_start_scan() {
        WifiManager wifiManager = (WifiManager) MApplication.getMApplication().getSystemService(Context.WIFI_SERVICE);
        if(wifiManager == null) {
            return;
        }
        wifiManager.startScan();
    }
    static public List<ScanResult> wifi_stop_scan() {
        WifiManager wifiManager = (WifiManager) MApplication.getMApplication().getSystemService(Context.WIFI_SERVICE);
        if(wifiManager == null) {
            return null;
        }
        return wifiManager.getScanResults();
    }
}
