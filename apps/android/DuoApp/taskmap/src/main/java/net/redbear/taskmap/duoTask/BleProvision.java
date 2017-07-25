package net.redbear.taskmap.duoTask;

import net.redbear.taskmap.DuoTaskObserver;
import net.redbear.taskmap.Step;

import java.util.ArrayList;

/**
 * Created by Dong on 16/1/14.
 */
public class BleProvision extends DuoTaskObserver {

    public BleProvision(){
        super(BleProvision.class.getName());
    }

    @Override
    protected void initStep(ArrayList<Step> steps) {
        steps.add(Step.BLE_IS_ON);
        steps.add(Step.BLE_SCAN);
        steps.add(Step.BLE_PROVISION);
        steps.add(Step.BLE_PROVISION_SCAN);
        steps.add(Step.BLE_PROVISION_SEND_PASSWORD);
        steps.add(Step.BLE_PROVISION_FINISH);
    }
}
