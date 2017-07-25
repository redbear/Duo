package net.redbear.board.controller.model.product;

/**
 * Created by dong on 3/16/16.
 */
public class Common {
    int SUPPORT_BLE  = 0x01;
    int SUPPORT_WIFI = 0x10;

    public static final String BLE_CONTROLLER_SERVICE_UUID = "713D0000-503E-4C75-BA94-3148F18D941E";
    public static final String BLE_CONTROLLER_COMMAND_UUID = "713D0003-503E-4C75-BA94-3148F18D941E";
    public static final String BLE_CONTROLLER_NOTIFY_UUID  = "713D0002-503E-4C75-BA94-3148F18D941E";

    //pin capability
    public static final int PIN_CAPABILITY_NONE    = 0x0000;
    public static final int PIN_CAPABILITY_DIGITAL = 0x0001;
    public static final int PIN_CAPABILITY_ANALOG  = 0x0010;
    public static final int PIN_CAPABILITY_PWM     = 0x0100;
    public static final int PIN_CAPABILITY_SERVO   = 0x1000;


    public static final int PIN_MODE_DISABLE        = 0x100000;
    public static final int PIN_MODE_IDE            = 0x1000000;
    public static final int PIN_MODE_DIGITAL_READ   = 0x00001;
    public static final int PIN_MODE_DIGITAL_WRITE  = 0x00010;
    public static final int PIN_MODE_ANALOG_READ    = 0x00100;
    public static final int PIN_MODE_PWM            = 0x01000;
    public static final int PIN_MODE_SERVO          = 0x10000;

    public static final int DUO_PIN_MODE_MODE_IDE   = 0xff;
    public static final int DUO_PIN_MODE_DIGITAL_READ   = 0;
    public static final int DUO_PIN_MODE_DIGITAL_WRITE  = 1;
    public static final int DUO_PIN_MODE_ANALOG_READ    = 2;
    public static final int DUO_PIN_MODE_PWM            = 3;
    public static final int DUO_PIN_MODE_SERVO          = 4;


    public static String getStringByPinMode(int pinMode){
        switch (pinMode){
            case PIN_MODE_IDE:
                return "Reset";
            case PIN_MODE_DIGITAL_READ:
                return "Digital Read";
            case PIN_MODE_DIGITAL_WRITE:
                return "Digital Write";
            case PIN_MODE_ANALOG_READ:
                return "Analog Read";
            case PIN_MODE_PWM:
                return "PWM";
            case PIN_MODE_SERVO:
                return "Servo";
        }
        return "";
    }

    public static int getPinModeByDuoPinMode(int duoPinMode){
        switch (duoPinMode){
            case DUO_PIN_MODE_MODE_IDE:
                return PIN_MODE_IDE;
            case DUO_PIN_MODE_DIGITAL_READ:
                return PIN_MODE_DIGITAL_READ;
            case DUO_PIN_MODE_DIGITAL_WRITE:
                return PIN_MODE_DIGITAL_WRITE;
            case DUO_PIN_MODE_ANALOG_READ:
                return PIN_MODE_ANALOG_READ;
            case DUO_PIN_MODE_PWM:
                return PIN_MODE_PWM;
            case DUO_PIN_MODE_SERVO:
                return PIN_MODE_SERVO;
        }
        return PIN_MODE_IDE;
    }

    public static int changeToDuoPinMode(int pinMode){
        switch (pinMode){
            case PIN_MODE_DISABLE:
            case PIN_MODE_IDE:
                return DUO_PIN_MODE_MODE_IDE;
            case PIN_MODE_DIGITAL_READ:
                return DUO_PIN_MODE_DIGITAL_READ;
            case PIN_MODE_DIGITAL_WRITE:
                return DUO_PIN_MODE_DIGITAL_WRITE;
            case PIN_MODE_ANALOG_READ:
                return DUO_PIN_MODE_ANALOG_READ;
            case PIN_MODE_PWM:
                return DUO_PIN_MODE_PWM;
            case PIN_MODE_SERVO:
                return DUO_PIN_MODE_SERVO;
        }
        return DUO_PIN_MODE_DIGITAL_READ;
    }

    public static int getControlModeMaxValue(int pinMode){
        if (pinMode == PIN_MODE_PWM){
            return 255;
        }
        if (pinMode == PIN_MODE_SERVO){
            return 180;
        }
        return 1;
    }

    public static String getControlModeString(int pinMode){
        if (pinMode == PIN_MODE_PWM){
            return "PWM";
        }
        if (pinMode == PIN_MODE_SERVO){
            return "Servo";
        }
        return "";
    }
    public static boolean isBarControl(int pinMode){
        if (pinMode == PIN_MODE_PWM || pinMode == PIN_MODE_SERVO){
            return true;
        }
        return false;
    }

}
