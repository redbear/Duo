package net.redbear.taskmap;

import java.util.ArrayList;

/**
 * Created by Dong on 16/1/14.
 */
public abstract class Subject {
    protected final ArrayList<DuoTaskObserver> mObservers = new ArrayList<>();

    public void registerObserver(DuoTaskObserver observer){
        if (observer == null) {
            throw new IllegalArgumentException("The observer is null.");
        }
        synchronized(mObservers) {
            if (mObservers.contains(observer)) {
                throw new IllegalStateException("Observer " + observer + " is already registered.");
            }
            mObservers.add(observer);
        }
    }
    public void unRegisterObserver(DuoTaskObserver observer){
        if (observer == null) {
            throw new IllegalArgumentException("The observer is null.");
        }
        synchronized(mObservers) {
            int index = mObservers.indexOf(observer);
            if (index == -1) {
                throw new IllegalStateException("Observer " + observer + " was not registered.");
            }
            mObservers.remove(index);
        }
    }

    public void unregisterAll() {
        synchronized(mObservers) {
            mObservers.clear();
        }
    }


}
