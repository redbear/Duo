package net.redbear.module.communicate.wifi.command;

import com.google.gson.annotations.SerializedName;

import net.redbear.module.communicate.wifi.WifiUtils;

/**
 * Created by Dong on 16/1/18.
 */
public class GetDeviceID extends Command {

    @Override
    public String getCommandData() {
        return WifiUtils.packageData("device-id",argsAsJsonString());
    }


    public static class Response implements net.redbear.module.communicate.wifi.command.Response{

        @SerializedName("id")
        public final String deviceIdHex;

        @SerializedName("c")
        public final int isClaimed;


        public Response(String deviceIdHex, int isClaimed) {
            this.deviceIdHex = deviceIdHex;
            this.isClaimed = isClaimed;
        }

        @Override
        public String toString() {
            return "Response{" +
                    "deviceIdHex='" + deviceIdHex + '\'' +
                    ", isClaimed=" + isClaimed +
                    '}';
        }

        @Override
        public boolean responseIsOK() {
            if (deviceIdHex != null)
                return true;
            return false;
        }
    }
}
