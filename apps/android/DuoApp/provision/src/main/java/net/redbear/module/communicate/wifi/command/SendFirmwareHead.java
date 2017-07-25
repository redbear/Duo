package net.redbear.module.communicate.wifi.command;

import android.content.Intent;
import android.util.Log;

import com.google.gson.annotations.SerializedName;

import net.redbear.module.communicate.wifi.WifiUtils;

/**
 * Created by Dong on 16/1/18.
 */
public class SendFirmwareHead extends Command {

    public static final int CHUNK_SIZE = 128;
    public final Integer file_length;
    public final Integer chunk_address;
    public final int chunk_size = CHUNK_SIZE;
    public final int file_store;




    public SendFirmwareHead(int file_length, Integer chunk_address,int file_store) {
        Log.e("sendFWHead", "file_length "+file_length+"  chunk_address "+chunk_address+"  file_store "+file_store);
        this.file_length = file_length;
        this.chunk_address = chunk_address;
        this.file_store = file_store;
    }


    @Override
    public String getCommandData() {
        Log.e("getCommandData",argsAsJsonString());
        return WifiUtils.packageData("prepare-update",argsAsJsonString());
    }


    public static class Response implements net.redbear.module.communicate.wifi.command.Response{

        @SerializedName("r")
        public final int responseCode;  // 0 == OK, non-zero == problem with index/net.redbear.redbearduo.data

        public Response(int responseCode) {
            this.responseCode = responseCode;
        }

        public boolean isOK() {
            return responseCode == 1;
        }

        @Override
        public String toString() {
            return "SendFirmwareHead.Response{" +
                    "responseCode=" + responseCode +
                    '}';
        }
        @Override
        public boolean responseIsOK() {
            if (responseCode == 1)
                return true;
            return false;
        }
    }
}
