package net.redbear.module.downloader;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Dong on 16/2/16.
 */
public class DuoFirmwareVersionInfo {
    @SerializedName("version")
    String firmwareVersion;
    @SerializedName("url")
    String firmwareURL;
    @SerializedName("size")
    int firmwareSize;
    String fileName;

    public String getFileName(){
        String[] a = firmwareURL.split("/");
        return a[a.length-1];
    }

    public String getFirmwareVersion() {
        return firmwareVersion;
    }

    public String getFirmwareURL() {
        return firmwareURL;
    }

    public int getFirmwareSize() {
        return firmwareSize;
    }

    @Override
    public String toString() {
        return "json to duo    version: "+firmwareVersion+"  url: "+firmwareURL+"  size: "+firmwareSize;
    }
}
