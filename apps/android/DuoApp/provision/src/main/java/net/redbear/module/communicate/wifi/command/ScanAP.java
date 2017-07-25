package net.redbear.module.communicate.wifi.command;

import java.util.Arrays;
import java.util.List;

import net.redbear.module.communicate.AP;
import net.redbear.module.communicate.wifi.WifiUtils;

/**
 * Created by Dong on 16/1/19.
 */
public class ScanAP extends Command {
    @Override
    public String getCommandData() {
        return WifiUtils.packageData("scan-ap", argsAsJsonString());
    }


    public static class Response implements net.redbear.module.communicate.wifi.command.Response{

        public final AP[] scans;

        public Response(AP[] scans) {
            this.scans = scans;
        }

        public List<AP> getAps() {
            return Arrays.asList(scans);
        }

        @Override
        public String toString() {
            return "Response{" +
                    "scans=" + Arrays.toString(scans) +
                    '}';
        }

        @Override
        public boolean responseIsOK() {
            if (scans != null)
                return true;
            return false;
        }
    }

}
