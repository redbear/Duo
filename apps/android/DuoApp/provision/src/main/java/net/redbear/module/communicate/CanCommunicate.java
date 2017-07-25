package net.redbear.module.communicate;

import java.io.File;

/**
 * Created by Dong on 16/1/5.
 */
public interface CanCommunicate {
    int STEP_GET_SYSTEM_INFO = 1;
    int STEP_SCAN = 2;
    int STEP_PASSWORD = 3;

    void connect();
    void getVersion();
    void OTAFile(String version);
    void scan();
    void sendPassword(AP ap,String password);
    void setCommunicateCallBack(CommunicateCallBack communicateCallBack);
    void disconnect();
    void checkDeviceHaveWifiProfile();
}
