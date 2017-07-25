package net.redbear.module.communicate.wifi.command;

import com.google.gson.annotations.SerializedName;

import net.redbear.module.communicate.wifi.WifiUtils;

/**
 * Created by Dong on 16/1/18.
 */
public class GetPublicKey extends Command {

    @Override
    public String getCommandData() {
        return WifiUtils.packageData("public-key",argsAsJsonString());
    }


    public static class Response implements net.redbear.module.communicate.wifi.command.Response{

        @SerializedName("r")
        public final int responseCode;

        // Hex-encoded public key, in DER format
        @SerializedName("b")
        public final String publicKey;

        public Response(int responseCode, String publicKey) {
            this.responseCode = responseCode;
            this.publicKey = publicKey;
        }

        @Override
        public String toString() {
            return "Response{" +
                    "responseCode=" + responseCode +
                    "publicKey=" + publicKey+
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
