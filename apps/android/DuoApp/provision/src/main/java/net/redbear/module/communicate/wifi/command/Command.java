package net.redbear.module.communicate.wifi.command;

import com.google.gson.Gson;

/**
 * Created by Dong on 16/1/18.
 */
public abstract class Command {

    abstract public String getCommandData();

    protected String argsAsJsonString() {
        Gson gson = new Gson();
        return gson.toJson(this);
    }
}
