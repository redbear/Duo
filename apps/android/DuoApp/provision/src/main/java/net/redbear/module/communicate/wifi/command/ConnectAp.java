package net.redbear.module.communicate.wifi.command;

import com.google.gson.annotations.SerializedName;

import net.redbear.module.communicate.wifi.WifiUtils;

/**
 * Created by Dong on 16/1/18.
 */
public class ConnectAp extends Command {

    @SerializedName("idx")
    public final int index = 0;

    @Override
    public String getCommandData() {
        return WifiUtils.packageData("connect-ap",argsAsJsonString());
    }


    public static class Response implements net.redbear.module.communicate.wifi.command.Response{

        @SerializedName("r")
        public final int responseCode;  // 0 == OK, non-zero == problem with index/net.redbear.redbearduo.data

        public Response(int responseCode) {
            this.responseCode = responseCode;
        }

        public boolean isOK() {
            return responseCode == 0;
        }

        @Override
        public String toString() {
            return "Response{" +
                    "responseCode=" + responseCode +
                    '}';
        }
        @Override
        public boolean responseIsOK() {
            if (responseCode == 0)
                return true;
            return false;
        }
    }
}
