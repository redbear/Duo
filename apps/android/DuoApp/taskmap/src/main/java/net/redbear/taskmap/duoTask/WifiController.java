package net.redbear.taskmap.duoTask;

import net.redbear.taskmap.DuoTaskObserver;
import net.redbear.taskmap.Step;

import java.util.ArrayList;

/**
 * Created by Dong on 16/1/14.
 */
public class WifiController extends DuoTaskObserver {

    public WifiController(){
        super(WifiController.class.getName());
    }

    @Override
    protected void initStep(ArrayList<Step> steps) {
        steps.add(Step.WIFI_ON);
        steps.add(Step.AP_IS_NOT_PROVISION_STATE);
        steps.add(Step.WIFI_MDNS_SCAN);
        steps.add(Step.WIFI_CONTROLLER);
    }
}
