package net.redbear.redbearduo.data.communication;

import android.bluetooth.BluetoothClass;
import android.content.Context;
import android.net.nsd.NsdManager;
import android.net.nsd.NsdServiceInfo;
import android.util.Log;

import java.net.InetAddress;

/**
 * Created by dong on 3/22/16.
 */
public class MDNSManage {
    private static final String TAG = "MDNSManage";

    private NsdManager mNsdManager;
    private NsdManager.DiscoveryListener mDiscoveryListener;
    private NsdManager.ResolveListener mResolveListener;

    private OnMDNSDevicesScanCallback onMDNSDevicesScanCallback;

    private boolean discoveryFlg = false;

    public MDNSManage(Context context){
        mNsdManager = (NsdManager) context.getSystemService(Context.NSD_SERVICE);
    }

    public void scanMDNSDevices(String serviceType){
        if (mNsdManager == null)
            return;
        if (discoveryFlg){
            return;
        }else {
            discoveryFlg = true;
        }

        mDiscoveryListener = new NsdManager.DiscoveryListener() {
            @Override
            public void onStartDiscoveryFailed(String serviceType, int errorCode) {
                Log.e(TAG, "onStartDiscoveryFailed........");
            }

            @Override
            public void onStopDiscoveryFailed(String serviceType, int errorCode) {
                Log.e(TAG, "onStopDiscoveryFailed........");
            }

            @Override
            public void onDiscoveryStarted(String serviceType) {
                Log.e(TAG, "onDiscoveryStarted........");
            }

            @Override
            public void onDiscoveryStopped(String serviceType) {
                Log.e(TAG, "onDiscoveryStopped........");
            }

            @Override
            public void onServiceFound(NsdServiceInfo serviceInfo) {
                Log.e(TAG, "onServiceFound........");
                Log.e(TAG, "onServiceFound........"+serviceInfo.toString());
                mResolveListener = new NsdManager.ResolveListener() {

                    @Override
                    public void onResolveFailed(NsdServiceInfo serviceInfo, int errorCode) {
                        Log.e(TAG, "Resolve failed" + errorCode);
                    }

                    @Override
                    public void onServiceResolved(NsdServiceInfo serviceInfo) {
                        Log.e(TAG, "onServiceResolved");
                        Log.e(TAG, "onServiceResolved........"+serviceInfo.toString());
                        if (onMDNSDevicesScanCallback != null)
                            onMDNSDevicesScanCallback.onScanCallback(serviceInfo.getServiceName(),serviceInfo.getHost().getHostAddress(),serviceInfo.getPort());
                    }
                };
                mNsdManager.resolveService(serviceInfo,mResolveListener);

            }

            @Override
            public void onServiceLost(NsdServiceInfo serviceInfo) {
                Log.e(TAG, "onServiceLost........");
            }
        };
        mNsdManager.discoverServices(serviceType, NsdManager.PROTOCOL_DNS_SD, mDiscoveryListener);
    }

    public void stopServiceDiscovery(){
        if (discoveryFlg){
            discoveryFlg = false;
        }else {
            return;
        }
        mNsdManager.stopServiceDiscovery(mDiscoveryListener);
    }


    public void setOnMDNSDevicesScanCallback(OnMDNSDevicesScanCallback onMDNSDevicesScanCallback) {
        this.onMDNSDevicesScanCallback = onMDNSDevicesScanCallback;
    }

    public interface OnMDNSDevicesScanCallback{
        void onScanCallback(String name,String IP,int port);
    }

}
