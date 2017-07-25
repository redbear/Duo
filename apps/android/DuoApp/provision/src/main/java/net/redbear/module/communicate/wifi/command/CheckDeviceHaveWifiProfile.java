package net.redbear.module.communicate.wifi.command;

import com.google.gson.annotations.SerializedName;

import net.redbear.module.communicate.wifi.WifiUtils;

/**
 * Created by Dong on 16/1/18.
 */
public class CheckDeviceHaveWifiProfile extends Command {

    @Override
    public String getCommandData() {
        return WifiUtils.packageData("check-credential",argsAsJsonString());
    }


    public static class Response implements net.redbear.module.communicate.wifi.command.Response{

        @SerializedName("has credentials")
        public final int hasCredentials;


        public Response(int hasCredentials) {
            this.hasCredentials = hasCredentials;
        }

        @Override
        public String toString() {
            return "Response{" +
                    "hasCredentials='" + hasCredentials+
                    '}';
        }

        @Override
        public boolean responseIsOK() {
            if (hasCredentials == 0 || hasCredentials == 1)
                return true;
            return false;
        }
    }
}
