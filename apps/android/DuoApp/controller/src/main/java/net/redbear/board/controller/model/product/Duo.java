package net.redbear.board.controller.model.product;

import net.redbear.board.controller.model.pin.Pin;

import java.util.LinkedHashSet;
import java.util.Set;
import static net.redbear.board.controller.model.product.Common.*;

/**
 * Created by dong on 3/16/16.
 */
public class Duo extends Board{
    private int supportModule;


    public Duo(){
        initDuo();
    }


    private void initDuo(){
        //left
        pinList.add(new Pin(0,"D0",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE|PIN_MODE_PWM,0));
        pinList.add(new Pin(1,"D1",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE|PIN_MODE_PWM,1));
        pinList.add(new Pin(2,"D2",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE|PIN_MODE_PWM,2));
        pinList.add(new Pin(3,"D3",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE|PIN_MODE_PWM,3));
        pinList.add(new Pin(4,"D4",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE|PIN_MODE_PWM,4));
        pinList.add(new Pin(5,"D5",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE,5));
        pinList.add(new Pin(6,"D6",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE,6));
        pinList.add(new Pin(7,"D7",PIN_MODE_DIGITAL_READ,7));
        pinList.add(new Pin(-1,"VBAT",PIN_MODE_DISABLE,8,PIN_MODE_DISABLE));
        pinList.add(new Pin(-1,"RST",PIN_MODE_DISABLE,9,PIN_MODE_DISABLE));

        //right
        pinList.add(new Pin(8,"A0",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE|PIN_MODE_PWM|PIN_MODE_ANALOG_READ,10));
        pinList.add(new Pin(9,"A1",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE|PIN_MODE_PWM|PIN_MODE_ANALOG_READ,11));
        pinList.add(new Pin(10,"A2",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE|PIN_MODE_ANALOG_READ,12));
        pinList.add(new Pin(11,"A3",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE|PIN_MODE_ANALOG_READ,13));
        pinList.add(new Pin(12,"A4",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE|PIN_MODE_PWM|PIN_MODE_ANALOG_READ|PIN_MODE_SERVO,14));
        pinList.add(new Pin(13,"A5",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE|PIN_MODE_PWM|PIN_MODE_ANALOG_READ|PIN_MODE_SERVO,15));
        pinList.add(new Pin(14,"A6",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE|PIN_MODE_PWM|PIN_MODE_ANALOG_READ,16));
        pinList.add(new Pin(15,"WKP",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE|PIN_MODE_PWM|PIN_MODE_ANALOG_READ,17));
        pinList.add(new Pin(16,"RX",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE|PIN_MODE_PWM,18));
        pinList.add(new Pin(17,"TX",PIN_MODE_DIGITAL_READ|PIN_MODE_DIGITAL_WRITE|PIN_MODE_PWM,19));
    }

}
