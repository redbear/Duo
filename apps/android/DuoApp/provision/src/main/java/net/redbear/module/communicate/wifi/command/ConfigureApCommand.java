package net.redbear.module.communicate.wifi.command;

import com.google.gson.annotations.SerializedName;

import net.redbear.module.communicate.wifi.WifiUtils;


/**
 * Configure the access point details to connect to when connect-ap is called. The AP doesn't have
 * to be in the list from scan-ap, allowing manual entry of hidden networks.
 */
public class ConfigureApCommand extends Command{

    public final Integer idx;

    public final String ssid;

    @SerializedName("pwd")
    public final String encryptedPasswordHex;

    @SerializedName("sec")
    public final int wifiSecurityType;

    @SerializedName("ch")
    public final Integer channel;

    public static Builder newBuilder() {
        return new Builder();
    }

    // private constructor -- use .newBuilder() instead.
    private ConfigureApCommand(int idx, String ssid, String encryptedPasswordHex,
                               int wifiSecurityType, int channel) {
        this.idx = idx;
        this.ssid = ssid;
        this.encryptedPasswordHex = encryptedPasswordHex;
        this.wifiSecurityType = wifiSecurityType;
        this.channel = channel;
    }

    @Override
    public String getCommandData() {
        return WifiUtils.packageData("configure-ap", argsAsJsonString());
    }


    public static class Response implements net.redbear.module.communicate.wifi.command.Response {

        @SerializedName("r")
        public final Integer responseCode;  // 0 == OK, non-zero == problem with index/net.redbear.redbearduo.data

        public Response(Integer responseCode) {
            this.responseCode = responseCode;
        }

        // FIXME: do this for the other ones with just the "responseCode" field
        public boolean isOk() {
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


    public static class Builder {
        private Integer idx;
        private String ssid;
        private String encryptedPasswordHex;
        private int securityType;
        private Integer channel;

        public Builder setIdx(int idx) {
            this.idx = idx;
            return this;
        }

        public Builder setSsid(String ssid) {
            this.ssid = ssid;
            return this;
        }

        public Builder setEncryptedPasswordHex(String encryptedPasswordHex) {
            this.encryptedPasswordHex = encryptedPasswordHex;
            return this;
        }

        public Builder setSecurityType(int securityType) {
            this.securityType = securityType;
            return this;
        }

        public Builder setChannel(int channel) {
            this.channel = channel;
            return this;
        }

        public ConfigureApCommand build() {
//            if (!all(ssid, securityType)
//                    || (truthy(encryptedPasswordHex) && securityType == WifiSecurity.OPEN)) {
//                throw new IllegalArgumentException(
//                        "One or more required arguments was not set on ConfigureApCommand");
//            }
            if (idx == null) {
                idx = 0;
            }
            return new ConfigureApCommand(idx, ssid, encryptedPasswordHex, securityType, channel);
        }
    }

}
