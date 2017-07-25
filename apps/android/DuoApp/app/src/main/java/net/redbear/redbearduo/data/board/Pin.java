package net.redbear.redbearduo.data.board;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Dong on 15/12/23.
 */
public class Pin {

    private String pin_name;

    @SerializedName("pin")
    private int pin;

    private int capability;

    @SerializedName("pinMode")
    private int mode;

    @SerializedName("net/redbear/redbearduo/data")
    private int[] data;


    public Pin(String pin_name,int pin,int capability){
        this.pin_name = pin_name;
        this.pin = pin;
        this.capability = capability;

    }



    public void setPin_name(String pin_name) {
        this.pin_name = pin_name;
    }

    public int getPin_name() {
        return pin;
    }

    public int getCapability() {
        return capability;
    }

    public int getMode() {
        return mode;
    }

    public void setMode(int mode) {
        this.mode = mode;
    }

    public int[] getData() {
        return data;
    }

    public void setData(int[] data) {
        this.data = data;
    }



    @Override
    public String toString() {
        return "pin :D"+pin+"  capability :"+capability+" mode :"+mode;
    }
}
