package net.redbear.taskmap;

import java.util.ArrayList;

/**
 * Created by Dong on 16/1/13.
 */
public class DuoTaskObservable extends Subject{

    private static DuoTaskObservable duoTaskObservable;
    private ArrayList<Step> steps = new ArrayList<>();

    private DuoTaskObservable(){}

    static public DuoTaskObservable getInstance(){
        synchronized (DuoTaskObservable.class){
            if (duoTaskObservable == null){
                duoTaskObservable = new DuoTaskObservable();
            }
        }
        return duoTaskObservable;
    }

    public void addTask(Step step){
        steps.add(step);
        notifyChanged(true,step);
    }

    public void backTask(Step step){
        if (step != steps.get(steps.size()-1)) return;
        steps.remove(steps.size()-1);
        notifyChanged(false,step);
    }

    void notifyChanged(boolean in,Step step) {
        synchronized(mObservers) {
            for (DuoTaskObserver observer : mObservers) {
                observer.notifyChanged(in,step);
            }
        }
    }


    @Override
    public String toString() {
        return steps.toString();
    }
}
