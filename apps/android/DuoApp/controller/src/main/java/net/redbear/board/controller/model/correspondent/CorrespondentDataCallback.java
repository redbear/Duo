package net.redbear.board.controller.model.correspondent;

/**
 * Created by dong on 3/22/16.
 */
public interface CorrespondentDataCallback {
    void onConnectSuccess(boolean isBLE);
    void onConnectFail();
    void onDisconnect();
    void onDataReceive(DataPackage d);
}
