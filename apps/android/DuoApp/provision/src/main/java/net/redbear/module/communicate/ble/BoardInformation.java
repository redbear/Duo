package net.redbear.module.communicate.ble;

import android.util.Log;

/**
 * Created by Dong on 16/1/5.
 */
public class BoardInformation {

    private static final int BOOT_V_Flg = 12;
    private static final int SYS_ONE_PART_Flg = 14;
    private static final int SYS_TWO_PART_Flg = 16;
    private static final int USER_PART_Flg = 18;
    private static final int RELEASE_LEN_FLG = 20;
    private static final int RELEASE_FLG = 21;

    private String deviceID = "";
    private String release_version = "";
    private int bootLoader_version;
    private int system_P1_version;
    private int system_P2_version;
    private int user_P_version;

    private BoardInformation(){}

    public static BoardInformation fromData(int[] data){
        if (data == null | data.length<21)
            return new BoardInformation();


        BoardInformation temp = new BoardInformation();
        //0 - 11 net.redbear.redbearduo.data.device id
        for(int i=0; i<12; i++){
            temp.deviceID += String.format("%x",data[i]);
        }
        temp.bootLoader_version = data[BOOT_V_Flg]*256 +  data[BOOT_V_Flg+1];
        temp.system_P1_version = data[SYS_ONE_PART_Flg]*256 +  data[SYS_ONE_PART_Flg+1];
        temp.system_P2_version = data[SYS_TWO_PART_Flg]*256 +  data[SYS_TWO_PART_Flg+1];
        temp.user_P_version = data[USER_PART_Flg]*256 +  data[USER_PART_Flg+1];
        for (int i=0;i<data[RELEASE_LEN_FLG];i++){
            temp.release_version += String.format("%c",data[i+RELEASE_FLG]);
        }
        Log.e("system info","deviceID...."+temp.deviceID+" release_version "+temp.release_version+"  bootLoader_version "+temp.bootLoader_version+"  system_P1_version "+temp.system_P1_version+" system_P2_version "+temp.system_P2_version+" user_P_version "+temp.user_P_version);
        return temp;
    }
}
