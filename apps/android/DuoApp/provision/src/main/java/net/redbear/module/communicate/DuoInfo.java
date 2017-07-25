package net.redbear.module.communicate;

/**
 * Created by Dong on 16/1/27.
 */
public class DuoInfo {
    private String deviceID;
    private int bootVersion;
    private int sysPartOneVersion;
    private int sysPartTwoVersion;

    public String getReleaseVersion() {
        return releaseVersion;
    }

    public void setReleaseVersion(String releaseVersion) {
        this.releaseVersion = releaseVersion;
    }

    private int userPartVersion;
    private String releaseVersion;

    public String getDeviceID() {
        return deviceID;
    }

    public void setDeviceID(String deviceID) {
        this.deviceID = deviceID;
    }

    public int getBootVersion() {
        return bootVersion;
    }

    public void setBootVersion(int bootVersion) {
        this.bootVersion = bootVersion;
    }

    public int getSysPartOneVersion() {
        return sysPartOneVersion;
    }

    public void setSysPartOneVersion(int sysPartOneVersion) {
        this.sysPartOneVersion = sysPartOneVersion;
    }

    public int getSysPartTwoVersion() {
        return sysPartTwoVersion;
    }

    public void setSysPartTwoVersion(int sysPartTwoVersion) {
        this.sysPartTwoVersion = sysPartTwoVersion;
    }

    public int getUserPartVersion() {
        return userPartVersion;
    }

    public void setUserPartVersion(int userPartVersion) {
        this.userPartVersion = userPartVersion;
    }

    @Override
    public String toString() {
        return "deviceID :"+deviceID+"  bootVersion :"+bootVersion+" sysPartOneVersion :"+sysPartOneVersion+"  sysPartTwoVersion :"+sysPartTwoVersion+"  userPartVersion :"+userPartVersion+"  releaseVersion :"+releaseVersion;
    }
}
