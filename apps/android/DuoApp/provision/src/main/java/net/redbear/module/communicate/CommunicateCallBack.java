package net.redbear.module.communicate;

import java.util.List;

/**
 * Created by Dong on 16/1/5.
 */
public interface CommunicateCallBack {
    void onConnectToDuo();
    void onConnectTimeout();
    void onDisconnectFromDuo(String msg);
    void onGetFirmVersion(String v);
    void onScanning();
    void onOTALogBack(String log,int progress,int task_n);
    void onOTAFinish();
    void onOTAFail();
    void onScanComplete(List<AP> ap);
    void onScanAnAP(AP ap);
    void onConnecting();
    void onCheckDeviceHaveWifiProfile(boolean have);
    void onConnectComplete(DuoIPInfo duoIPInfo);
    void onBoardConnectToAPError(Exception e);
}
