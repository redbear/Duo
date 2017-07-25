package net.redbear.module.communicate;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Dong on 16/1/6.
 */
public class AP implements Cloneable{
    public static final int WICED_SECURITY_OPEN = 0;                                            //"Open"
    public static final int WICED_SECURITY_WEP_PSK = 0x0001;                                    //"WEP"
    public static final int WICED_SECURITY_WEP_SHARED = (0x0001 | 0x00008000);
    public static final int WICED_SECURITY_WPA_TKIP_PSK = (0x00200000 | 0x0002);                //"WPA TKIP"
    public static final int WICED_SECURITY_WPA_AES_PSK = (0x00200000 | 0x0004);                //"WPA AES"
    public static final int WICED_SECURITY_WPA2_AES_PSK = (0x00400000 | 0x0004);               //"WPA2 AES"
    public static final int WICED_SECURITY_WPA2_TKIP_PSK = (0x00400000 | 0x0002);              //"WPA2 TKIP"
    public static final int WICED_SECURITY_WPA2_MIXED_PSK = (0x00400000 | 0x0004 | 0x0002);     //"WPA2 Mixed"
    String[] SECURITY_String ={"Open","WEP","WPA TKIP","WPA AES","WPA2 AES","WPA2 TKIP","WPA2 Mixed"};

    public static final int RSSI_VS = -50;
    public static final int RSSI_S = -70;
    public static final int RSSI_n = -80;
    public static final int RSSI_w = -90;
    public static final int RSSI_vw = -100;


    @SerializedName("ssid")
    private String ssid;
    @SerializedName("rssi")
    private int rssi;
    @SerializedName("sec")
    private int security;
    //private int num;

    @SerializedName("ch")
    private Integer channel;


    public String getSsid() {
        return ssid;
    }

    public void setSsid(String ssid) {
        this.ssid = ssid;
    }

    public int getRssi() {
        return rssi;
    }

    public void setRssi(int rssi) {
        this.rssi = rssi;
    }

    public int getSecurity() {
        return security;
    }

    public void setSecurity(int security) {
        this.security = security;
    }
    public Integer getChannel() {
        return channel;
    }

    public void setChannel(Integer channel) {
        this.channel = channel;
    }

    public String getSEC(int value){
        if (value == WICED_SECURITY_OPEN) {
            return SECURITY_String[0];
        }else if(value == WICED_SECURITY_WEP_PSK){
            return SECURITY_String[1];
        }else if(value == WICED_SECURITY_WPA_TKIP_PSK){
            return SECURITY_String[2];
        }else if(value == WICED_SECURITY_WPA_AES_PSK){
            return SECURITY_String[3];
        }else if(value == WICED_SECURITY_WPA2_AES_PSK){
            return SECURITY_String[4];
        }else if(value == WICED_SECURITY_WPA2_TKIP_PSK){
            return SECURITY_String[5];
        }else if(value == WICED_SECURITY_WPA2_MIXED_PSK){
            return SECURITY_String[6];
        }
        return "UNKNOWN";
    }

    @Override
    public String toString() {
        return "  ssid : "+ssid+"  sec : "+getSEC(security)+"  rssi :"+rssi;
    }
}
