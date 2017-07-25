package net.redbear.taskmap;

import android.util.Log;

import java.util.ArrayList;

/**
 * Created by Dong on 16/1/14.
 */
public abstract class DuoTaskObserver {

    protected ArrayList<Step> steps = new ArrayList<>();
    protected Step nextStep;
    private String TAG = "";

    protected DuoTaskObserver(){
        initStep(steps);
        if (steps.size() != 0){
            nextStep = steps.get(0);
        }
    }

    protected DuoTaskObserver(String tag){
        TAG = tag;
        initStep(steps);
        if (steps.size() != 0){
            nextStep = steps.get(0);
        }
    }

    public void notifyChanged(boolean in,Step task){
        if (in){
            addStep(task);
        }else {
            deleteStep(task);
        }
    }

    abstract protected void initStep(ArrayList<Step> steps);

    private void addStep(Step task){
        if (task == nextStep){
            Log.e(TAG,"....add step..."+task);
            nextStep = steps.get(steps.indexOf(nextStep)+1);
        }
    }
    private void deleteStep(Step task){
        int step = steps.indexOf(nextStep);
        if (step == 0)
            return;
        Log.e(TAG,"....deleteStep..."+task);
        if (steps.get(step-1) == task){
            nextStep = task;
        }
    }

    @Override
    public String toString() {
        return steps.toString();
    }


}
