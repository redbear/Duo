package net.redbear.board.controller.view.customView;

/**
 * Created by dong on 3/23/16.
 */
public interface PinViewCallback {
    void onPinClick(int num,int pinListNum);
    void onControlClick(int num,int pinListNum,int pinMode);
    void onResetAllClick();
}
