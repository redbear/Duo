package net.redbear.redbearduo.data.communication;

import net.redbear.redbearduo.data.communication.wifi.DuoWifiUtils;
import static net.redbear.redbearduo.data.communication.wifi.DuoWifiUtils.*;
import static net.redbear.redbearduo.data.communication.ble.DuoBLEUtils.*;

/**
 * Created by Dong on 16/1/28.
 */
public class CommunicationManage {
    public enum CommunicationState{
        BLE_OPEN_ONLY,
        WIFI_OPEN_ONLY,
        WIFI_BLE_OPEN,
        WIFI_BLE_NONE_OPEN
    }
    public enum CommunicationSupport{
        SUPPORT_BLE_ONLY,SUPPORT_WIFI_ONLY,SUPPORT_BLE_AND_WIFI,SUPPORT_NONE
    }


    private CommunicationSupport communicationSupport;
    private CommunicationState communicationState;


    public CommunicationManage(){
        checkSupport();
    }


    public CommunicationSupport getCommunicationSupport(){
        return communicationSupport;
    }

    public CommunicationState getCommunicationState() {
        getState();
        return communicationState;
    }
    public CommunicationState getCommunicationState_static() {
        return communicationState;
    }

    private void checkSupport(){
        if (wifi_check_support()){
            if (ble_check_support()){
                communicationSupport = CommunicationSupport.SUPPORT_BLE_AND_WIFI;
            }else {
                communicationSupport = CommunicationSupport.SUPPORT_WIFI_ONLY;
            }
        }else {
            if (ble_check_support()){
                communicationSupport = CommunicationSupport.SUPPORT_BLE_ONLY;
            }else {
                communicationSupport = CommunicationSupport.SUPPORT_NONE;
            }
        }
    }




    private void getState(){
        switch (communicationSupport){
            case SUPPORT_BLE_ONLY:
                if (ble_is_on()){
                    communicationState = CommunicationState.BLE_OPEN_ONLY;
                }
                break;
            case SUPPORT_WIFI_ONLY:
                if (wifi_is_on()){
                    communicationState = CommunicationState.WIFI_OPEN_ONLY;
                }
                break;
            case SUPPORT_BLE_AND_WIFI:
                if (ble_is_on()){
                    communicationState = CommunicationState.BLE_OPEN_ONLY;
                    if (wifi_is_on()){
                        if (communicationState == CommunicationState.BLE_OPEN_ONLY)
                            communicationState = CommunicationState.WIFI_BLE_OPEN;
                        else communicationState = CommunicationState.WIFI_OPEN_ONLY;
                    }
                }else {
                    if (wifi_is_on()){
                        communicationState = CommunicationState.WIFI_OPEN_ONLY;
                    }else {
                        communicationState = CommunicationState.WIFI_BLE_NONE_OPEN;
                    }
                }
                break;
        }
    }



}
