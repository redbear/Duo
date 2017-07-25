package net.redbear.redbearduo.data.board.redbearBoards;

import java.util.HashMap;

import net.redbear.board.controller.model.product.Common;
import net.redbear.redbearduo.data.board.Board;
import net.redbear.redbearduo.data.board.Pin;

/**
 * Duo(2016.1) is RedBear's net.redbear.redbearduo.data.board which have WIFI,BLE net.redbear.module.pins :12X2
 */
public class Duo extends Board {

    public Duo(){

    }

    private void initPins(){
        if (pins == null){
            pins = new HashMap<>();
        }
        pins.put(0,new Pin("D0",0, Common.PIN_CAPABILITY_DIGITAL| Common.PIN_CAPABILITY_PWM));
        pins.put(1,new Pin("D1",1, Common.PIN_CAPABILITY_DIGITAL| Common.PIN_CAPABILITY_PWM| Common.PIN_CAPABILITY_SERVO));
        pins.put(2,new Pin("D2",2, Common.PIN_CAPABILITY_DIGITAL| Common.PIN_CAPABILITY_PWM| Common.PIN_CAPABILITY_SERVO));
        pins.put(3,new Pin("D3",3, Common.PIN_CAPABILITY_DIGITAL| Common.PIN_CAPABILITY_PWM| Common.PIN_CAPABILITY_SERVO));
        pins.put(4,new Pin("D4",4, Common.PIN_CAPABILITY_DIGITAL| Common.PIN_CAPABILITY_PWM));
        pins.put(5,new Pin("D5",5, Common.PIN_CAPABILITY_DIGITAL));
        pins.put(6,new Pin("D6",6, Common.PIN_CAPABILITY_DIGITAL));
        pins.put(7,new Pin("D7",7, Common.PIN_CAPABILITY_DIGITAL));
        pins.put(8,new Pin("GND",-1, Common.PIN_CAPABILITY_NONE));
        pins.put(9,new Pin("VBAT",-1, Common.PIN_CAPABILITY_NONE));
        pins.put(10,new Pin("RST",-1, Common.PIN_CAPABILITY_NONE));
        pins.put(11,new Pin("3V3",-1, Common.PIN_CAPABILITY_NONE));
        pins.put(12,new Pin("D8",10, Common.PIN_CAPABILITY_DIGITAL| Common.PIN_CAPABILITY_PWM| Common.PIN_CAPABILITY_ANALOG| Common.PIN_CAPABILITY_SERVO));
        pins.put(13,new Pin("D9",11, Common.PIN_CAPABILITY_DIGITAL| Common.PIN_CAPABILITY_PWM| Common.PIN_CAPABILITY_ANALOG| Common.PIN_CAPABILITY_SERVO));
        pins.put(14,new Pin("D10",12, Common.PIN_CAPABILITY_DIGITAL| Common.PIN_CAPABILITY_PWM));
        pins.put(15,new Pin("D11",13, Common.PIN_CAPABILITY_DIGITAL| Common.PIN_CAPABILITY_PWM));
        pins.put(16,new Pin("D12",14, Common.PIN_CAPABILITY_DIGITAL| Common.PIN_CAPABILITY_PWM| Common.PIN_CAPABILITY_ANALOG));
        pins.put(17,new Pin("D13",15, Common.PIN_CAPABILITY_DIGITAL| Common.PIN_CAPABILITY_PWM| Common.PIN_CAPABILITY_ANALOG));
        pins.put(18,new Pin("D14",16, Common.PIN_CAPABILITY_DIGITAL| Common.PIN_CAPABILITY_PWM| Common.PIN_CAPABILITY_ANALOG));
        pins.put(19,new Pin("D15",17, Common.PIN_CAPABILITY_DIGITAL| Common.PIN_CAPABILITY_PWM| Common.PIN_CAPABILITY_ANALOG));
        pins.put(20,new Pin("D16",-1, Common.PIN_CAPABILITY_NONE));
        pins.put(21,new Pin("D17",-1, Common.PIN_CAPABILITY_NONE));
        pins.put(22,new Pin("GND",-1, Common.PIN_CAPABILITY_NONE));
        pins.put(23,new Pin("VIN",-1, Common.PIN_CAPABILITY_NONE));
    }
}
