package net.redbear.board.controller.model.product;

import android.content.Intent;
import android.util.Log;

import net.redbear.board.controller.model.pin.Pin;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/**
 * Created by dong on 3/23/16.
 */
public class Board {
    protected List<Pin> pinList;

    protected Board(){
        pinList = new ArrayList<>();
    }


    public int getPinAmount(){
        return pinList.size();
    }

    public Pin getPin(int pinNum){
        return pinList.get(pinNum);
    }
    public boolean isPinModeIDE(int pinNum){
        return pinList.get(pinNum).getPinMode() == Common.PIN_MODE_IDE;
    }

    public ArrayList<Integer> getPinModeSupport(int pinNum){
        return pinList.get(pinNum).getSupportPinNumMode();
    }


    public void notifyPinData(int pin,int pinMode,int value){
        for(Pin p : pinList){
            if (p.getPinNum() == pin){
                p.setPinMode(pinMode);
                p.setValue(value);
            }
        }
    }

    public void resetAll(){
        for(Pin p : pinList){
            if (p.getPinMode() != Common.PIN_MODE_DISABLE){
                p.setPinMode(Common.PIN_MODE_IDE);
                p.setValue(0);
            }
        }
    }




    public int getPinViewNum(int pin){
        for(Pin p : pinList){
            if (p.getPinNum() == pin){
                return p.getPinViewNum();
            }
        }
        return -1;
    }


}
