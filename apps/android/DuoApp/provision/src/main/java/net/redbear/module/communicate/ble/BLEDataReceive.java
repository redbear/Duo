package net.redbear.module.communicate.ble;

import android.util.Log;

import net.redbear.module.communicate.AP;
import net.redbear.module.communicate.DuoInfo;
import net.redbear.module.communicate.DuoIPInfo;

import static net.redbear.module.communicate.ble.BLEUtils.*;


/**
 * Created by Dong on 16/1/6.
 */
public class BLEDataReceive {
    //ap info
    private static final int PACKET_MAX_LEN = 20;
    private static final int PACKAGE_LEN_FLG = 0;
    private static final int CMD_FLG = 1;
    private static final int AP_STATE_FLG = 2;
    private static final int RSSI_FLG = 3;
    private static final int CHANNEL_FLG = 5;
    private static final int MAC_Flg = 6;
    private static final int SECURITY_FLG = 12;
    private static final int SSID_LEN_FLG = 16;
    private static final int SSID_FLG = 17;

    //duo version info
    private static final int DEVICE_ID_FLG = 2;
    private static final int BOOT_VERSION_FLG = 14;
    private static final int SYS_PART_ONE_VERSION_FLG = 16;
    private static final int SYS_PART_TWO_VERSION_FLG = 18;
    private static final int USER_PART_VERSION_FLG = 20;
    private static final int RELEASE_VERSION_LEN_FLG = 22;
    private static final int RELEASE_VERSION_FLG = 23;

    //DUO IP INFO
    private static final int DUO_IP_VERSION_FLG = 2;
    private static final int DUO_IP_FLG = 3;
//    private static final int GATEWAY_IP_VERSION_FLG = 2;
//    private static final int GATEWAY_IP_FLG = 2;
//    private static final int GATEWAY_MAC_FLG = 2;
//    private static final int GATEWAY_SSID_FLG = 2;







    private int len;
    private int[] dataBuff;
    private BleDataReceiveCallBack bleDataReceiveCallBack;

    public BLEDataReceive(){}
    public BLEDataReceive(BleDataReceiveCallBack bleDataReceiveCallBack){
        this.bleDataReceiveCallBack = bleDataReceiveCallBack;
    }


    public void receive(int[] data) throws BleDataReceiveException {
        Log.e("receive data","111111111"+"   "+data.length);
        if (data.length < 1)
            throw new BleDataReceiveException("source net.redbear.redbearduo.data error");
        if (len == 0){
            //first package
            if (data[0] > 2){
                dataBuff = data;
                len = data[0] - data.length;
            }else {
                throw new BleDataReceiveException("source net.redbear.redbearduo.data error");
            }
        }else if (len > 0){
            //continue package
            dataBuff = arrayAdd(dataBuff,data);
            len -= data.length;
        }
        if (check_receive_data_finish()){
            dataCallBack();
        }
    }

    private boolean check_receive_data_finish() throws BleDataReceiveException {
        if (len < 0)
            throw new BleDataReceiveException("data maybe lost");
        if (len == 0)
            return true;
        return false;
    }

    private void dataCallBack(){
        if (bleDataReceiveCallBack == null)
            return;
        Log.e("dataCallBack ......",dataBuff[CMD_FLG]+"");
        switch (dataBuff[CMD_FLG]){
            case BLE_PROVISION_COMMAND_GET_SYS_INFO:
                bleDataReceiveCallBack.onDuoInfoCallBack(dataToDuoInfo());
                break;
            case BLE_PROVISION_COMMAND_NOTIFY_AP:
                Log.e("receive ......", "BLE_PROVISION_COMMAND_NOTIFY_AP");
                bleDataReceiveCallBack.onAPCallBack(dataToAP());
                break;
            case BLE_PROVISION_COMMAND_NOTIFY_IP_CONFIG:
                bleDataReceiveCallBack.onDuoIPInfoCallBack(dataToDuoIPInfo());
                break;
        }
    }

    private AP dataToAP(){

        AP ap = new AP();

        //rssi
        // 0xffa1   ->  -83
        char rssi = (char)(~(dataBuff[RSSI_FLG+1]*256 + dataBuff[RSSI_FLG]));
        ap.setRssi(-((int) rssi));

        ap.setChannel(dataBuff[CHANNEL_FLG]);
        ap.setSecurity(dataBuff[SECURITY_FLG] + dataBuff[SECURITY_FLG + 1] * 256  + dataBuff[SECURITY_FLG+2] * 65536+ dataBuff[SECURITY_FLG+3] * 16777216);

        StringBuffer ssid = new StringBuffer("");
        for (int i=0;i<dataBuff[SSID_LEN_FLG];i++){
            ssid.append((char)dataBuff[i+SSID_FLG]);
        }
        ap.setSsid(ssid.toString());
        Log.e("....",ap.toString());
        return ap;
    }



    private DuoInfo dataToDuoInfo(){
        DuoInfo duoInfo = new DuoInfo();

        StringBuffer id = new StringBuffer("");
        for (int i=0;i<12;i++){
            id.append(String.format("%x",dataBuff[i+DEVICE_ID_FLG]));
        }

        duoInfo.setDeviceID(id.toString());
        duoInfo.setBootVersion(dataBuff[BOOT_VERSION_FLG] + dataBuff[BOOT_VERSION_FLG + 1] * 256);
        duoInfo.setSysPartOneVersion(dataBuff[SYS_PART_ONE_VERSION_FLG] + dataBuff[SYS_PART_ONE_VERSION_FLG + 1] * 256);
        duoInfo.setSysPartTwoVersion(dataBuff[SYS_PART_TWO_VERSION_FLG] + dataBuff[SYS_PART_TWO_VERSION_FLG + 1] * 256);
        duoInfo.setUserPartVersion(dataBuff[USER_PART_VERSION_FLG] + dataBuff[USER_PART_VERSION_FLG + 1] * 256);

        int releaseVLen = dataBuff[RELEASE_VERSION_LEN_FLG];
        StringBuffer releaseV = new StringBuffer("");
        for (int i=0;i<releaseVLen;i++){
            releaseV.append((char)dataBuff[RELEASE_VERSION_FLG+i]);
        }
        duoInfo.setReleaseVersion(releaseV.toString());

        return duoInfo;
    }

    private DuoIPInfo dataToDuoIPInfo(){
        int offset = 0;
        DuoIPInfo duoIPInfo = new DuoIPInfo();

        duoIPInfo.setDuoIPVersion(dataBuff[DUO_IP_VERSION_FLG]);
        offset = DUO_IP_FLG;
        duoIPInfo.setDuoIP(getIPWithSplit(offset, duoIPInfo.getDuoIPVersion(), '.'));
        offset += duoIPInfo.getDuoIPVersion();
        duoIPInfo.setGateWayIPVersion(dataBuff[offset]);
        offset++;
        duoIPInfo.setGateWayIP(getIPWithSplit(offset, duoIPInfo.getGateWayIPVersion(), '.'));
        offset += duoIPInfo.getGateWayIPVersion();
        duoIPInfo.setGateWayMAC(getMACWithSplit(offset, 6, ':'));
        offset += 6;
        int ssidLen = dataBuff[offset];
        offset++;
        StringBuffer ssid = new StringBuffer("");
        for (int i=0;i<ssidLen;i++){
            ssid.append((char)dataBuff[i + offset]);
        }
        duoIPInfo.setGateWaySSID(ssid.toString());

        return duoIPInfo;
    }


    public void setBleDataReceiveCallBack(BleDataReceiveCallBack bleDataReceiveCallBack){
        this.bleDataReceiveCallBack = bleDataReceiveCallBack;
    }



    private String getIPWithSplit(int offset,int ipVersion,char split){
        StringBuffer ip = new StringBuffer();
        for (int i=0;i<ipVersion;i++){
            if (i != 0){
                ip.append(split);
            }
            ip.append(dataBuff[offset+ipVersion-i-1]);
        }
        return ip.toString();
    }
    private String getMACWithSplit(int offset,int ipVersion,char split){
        StringBuffer ip = new StringBuffer();
        for (int i=0;i<ipVersion;i++){
            if (i != 0){
                ip.append(split);
            }
            ip.append(String.format("%x",dataBuff[offset+i]));
        }
        return ip.toString();
    }


    public interface BleDataReceiveCallBack{
        void onAPCallBack(AP ap);
        void onDuoInfoCallBack(DuoInfo duoInfo);
        void onDuoIPInfoCallBack(DuoIPInfo duoIPInfo);
    }
}
