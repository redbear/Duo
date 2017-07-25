package net.redbear.board.controller.model.correspondent;

import com.google.gson.annotations.SerializedName;

/**
 * Created by dong on 3/23/16.
 */
public class DataPackage {
    @SerializedName("cmd")
    private String command;
    private int pin;
    @SerializedName("pinMode")
    private int pinMode;
    private int data;

    public String getCommand() {
        return command;
    }

    public int getPin() {
        return pin;
    }

    public int getPinMode() {
        return pinMode;
    }

    public int getData() {
        return data;
    }

    public void setData(int data) {
        this.data = data;
    }

    public void setCommand(String command) {
        this.command = command;
    }

    public void setPin(int pin) {
        this.pin = pin;
    }

    public void setPinMode(int pinMode) {
        this.pinMode = pinMode;
    }

    public static class Builder{
        DataPackage d;
        public Builder(){
            d = new DataPackage();
        }
        public Builder setCommand(String command) {
            d.command = command;
            return this;
        }
        public Builder setPin(int pin) {
            d.pin = pin;
            return this;
        }
        public Builder setPinMode(int pinMode) {
            d.pinMode = pinMode;
            return this;
        }

        public Builder setData(int data) {
            d.data = data;
            return this;
        }

        public DataPackage build(){
            return d;
        }
    }


    @Override
    public String toString() {
        return "command :"+command+"   pin "+pin+"    pinMode "+pinMode+"  data  "+data;
    }
}
