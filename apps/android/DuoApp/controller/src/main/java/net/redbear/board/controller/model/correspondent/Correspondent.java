package net.redbear.board.controller.model.correspondent;

/**
 * Created by dong on 3/22/16.
 */
public interface Correspondent {
    void connect();
    void disconnect();
    void setPinMode(int pin,int pinMode);
    void getPinValue(int pin);
    void setPinData(int pin,int pinMode,int data);
    void resetAll();
    void setCorrespondentDataCallback(CorrespondentDataCallback callback);
}
