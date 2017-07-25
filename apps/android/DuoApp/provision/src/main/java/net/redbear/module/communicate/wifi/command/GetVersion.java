package net.redbear.module.communicate.wifi.command;

import com.google.gson.annotations.SerializedName;

import net.redbear.module.communicate.wifi.WifiUtils;

/**
 * Created by Dong on 16/1/18.
 */
public class GetVersion extends Command {

    @Override
    public String getCommandData() {
        return WifiUtils.packageData("version",argsAsJsonString());
    }


    public static class Response implements net.redbear.module.communicate.wifi.command.Response{

        @SerializedName("release string")
        public final String releaseVersion;
        @SerializedName("bootloader")
        public final String bootloaderVersion;
        @SerializedName("system part1")
        public final String systemPart1Version;
        @SerializedName("system part2")
        public final String systemPart2Version;
        @SerializedName("user part")
        public final String userPartVersion;



        public Response(String releaseVersion,String bootloaderVersion,String systemPart1Version,String systemPart2Version,String userPartVersion) {
            this.releaseVersion = releaseVersion;
            this.bootloaderVersion = bootloaderVersion;
            this.systemPart1Version = systemPart1Version;
            this.systemPart2Version = systemPart2Version;
            this.userPartVersion = userPartVersion;
        }

        @Override
        public String toString() {
            return "Response{" +
                    "release string:"+releaseVersion+",bootloader:"+bootloaderVersion+",system part1:"+systemPart1Version+",system part2:"+systemPart2Version+
                    ",user part:"+userPartVersion+
                    '}';
        }

        @Override
        public boolean responseIsOK() {
            if (releaseVersion != null)
                return true;
            return false;
        }
    }
}
