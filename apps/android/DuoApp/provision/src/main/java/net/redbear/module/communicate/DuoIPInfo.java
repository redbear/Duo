package net.redbear.module.communicate;

/**
 * Created by Dong on 16/2/1.
 */
public class DuoIPInfo {
    private int duoIPVersion;
    private String duoIP;
    private String gateWaySSID;
    private int gateWayIPVersion;
    private String gateWayIP;
    private String gateWayMAC;

    public int getDuoIPVersion() {
        return duoIPVersion;
    }

    public void setDuoIPVersion(int duoIPVersion) {
        this.duoIPVersion = duoIPVersion;
    }

    public String getDuoIP() {
        return duoIP;
    }

    public void setDuoIP(String duoIP) {
        this.duoIP = duoIP;
    }

    public String getGateWaySSID() {
        return gateWaySSID;
    }

    public void setGateWaySSID(String gateWaySSID) {
        this.gateWaySSID = gateWaySSID;
    }

    public int getGateWayIPVersion() {
        return gateWayIPVersion;
    }

    public void setGateWayIPVersion(int gateWayIPVersion) {
        this.gateWayIPVersion = gateWayIPVersion;
    }

    public String getGateWayIP() {
        return gateWayIP;
    }

    public void setGateWayIP(String gateWayIP) {
        this.gateWayIP = gateWayIP;
    }

    public String getGateWayMAC() {
        return gateWayMAC;
    }

    public void setGateWayMAC(String gateWayMAC) {
        this.gateWayMAC = gateWayMAC;
    }

    @Override
    public String toString() {
        return "duoIPVersion :"+duoIPVersion+"  duoIP :"+duoIP+" gateWaySSID :"+gateWaySSID+"  gateWayIPVersion :"+gateWayIPVersion+"  gateWayIP :"+gateWayIP+"  gateWayMAC :"+gateWayMAC;
    }
}
