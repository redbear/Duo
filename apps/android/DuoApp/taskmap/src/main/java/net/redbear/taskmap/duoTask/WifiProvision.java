package net.redbear.taskmap.duoTask;

import net.redbear.taskmap.DuoTaskObserver;
import net.redbear.taskmap.Step;

import java.util.ArrayList;

/**
 * Created by Dong on 16/1/14.
 */
public class WifiProvision extends DuoTaskObserver {

    public WifiProvision(){
        super(WifiProvision.class.getName());
    }

    @Override
    protected void initStep(ArrayList<Step> steps) {
        steps.add(Step.WIFI_ON);
        steps.add(Step.AP_IS_PROVISION_STATE);
        steps.add(Step.WIFI_PROVISION);
        steps.add(Step.WIFI_PROVISION_SCAN);
        steps.add(Step.WIFI_PROVISION_SEND_PASSWORD);
        steps.add(Step.WIFI_PROVISION_FINISH);
    }
}
