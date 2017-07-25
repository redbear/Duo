package net.redbear.board.controller.model.pin;

import net.redbear.board.controller.model.product.Common;

import java.util.ArrayList;

/**
 * Created by dong on 3/16/16.
 */
public class Pin {


    private int pinNum;
    private int pinViewNum;
    private String pinName;
    private int supportPinNumMode;

    private int pinMode;
    private int value;

    public Pin(int pinNum,String pinName,int supportPinNumMode,int pinViewNum){
        this.pinNum = pinNum;
        this.pinName = pinName;
        this.supportPinNumMode = supportPinNumMode;
        this.pinViewNum = pinViewNum;
        pinMode = Common.PIN_MODE_IDE;
    }
    public Pin(int pinNum,String pinName,int supportPinNumMode,int pinViewNum,int pinMode){
        this.pinNum = pinNum;
        this.pinName = pinName;
        this.pinViewNum = pinViewNum;
        this.supportPinNumMode = supportPinNumMode;
        this.pinMode = pinMode;
    }



    public int getPinNum() {
        return pinNum;
    }

    public void setPinNum(int pinNum) {
        this.pinNum = pinNum;
    }

    public String getPinName() {
        return pinName;
    }

    public void setPinName(String pinName) {
        this.pinName = pinName;
    }

    public void setSupportPinNumMode(int supportPinNumMode) {
        this.supportPinNumMode = supportPinNumMode;
    }

    public int getPinMode() {
        return pinMode;
    }

    public void setPinMode(int pinMode) {
        this.pinMode = pinMode;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }

    public int getPinViewNum() {
        return pinViewNum;
    }

    public ArrayList<Integer> getSupportPinNumMode(){
        ArrayList<Integer> a = new ArrayList<>();
        if ((supportPinNumMode & Common.PIN_MODE_DIGITAL_READ) != 0)
            a.add(Common.PIN_MODE_DIGITAL_READ);
        if ((supportPinNumMode & Common.PIN_MODE_DIGITAL_WRITE) != 0)
            a.add(Common.PIN_MODE_DIGITAL_WRITE);
        if ((supportPinNumMode & Common.PIN_MODE_ANALOG_READ) != 0)
            a.add(Common.PIN_MODE_ANALOG_READ);
        if ((supportPinNumMode & Common.PIN_MODE_PWM) != 0)
            a.add(Common.PIN_MODE_PWM);
        if ((supportPinNumMode & Common.PIN_MODE_SERVO) != 0)
            a.add(Common.PIN_MODE_SERVO);
        if (pinMode != Common.PIN_MODE_IDE)
            a.add(Common.PIN_MODE_IDE);
        return a;
    }

    @Override
    public String toString() {
        return "pinName :"+pinName+"  pinNum :"+pinNum+"  value :"+value+"  pinMode :"+pinMode;
    }
}
