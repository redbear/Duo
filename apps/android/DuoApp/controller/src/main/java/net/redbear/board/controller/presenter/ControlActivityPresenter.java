package net.redbear.board.controller.presenter;

import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.Intent;

import net.redbear.board.controller.model.correspondent.BLECorrespondent;
import net.redbear.board.controller.model.correspondent.Correspondent;
import net.redbear.board.controller.model.correspondent.CorrespondentDataCallback;
import net.redbear.board.controller.model.correspondent.WIFICorrespondent;
import net.redbear.board.controller.model.product.Board;
import net.redbear.board.controller.model.product.Duo;

/**
 * Created by dong on 3/22/16.
 */
public class ControlActivityPresenter {

    private Correspondent correspondent;
    private Board board;

    public ControlActivityPresenter(Context context,String ip, int port, BluetoothDevice bleDevice, CorrespondentDataCallback correspondentDataCallback){
        if (bleDevice != null){
            correspondent = new BLECorrespondent(context,bleDevice);
        }else {
            correspondent = new WIFICorrespondent(ip,port);
        }
        correspondent.setCorrespondentDataCallback(correspondentDataCallback);
        correspondent.connect();
        board = new Duo();
    }

    public Board getBoard() {
        return board;
    }

    public Correspondent getCorrespondent() {
        return correspondent;
    }

    public void destroy(){
        correspondent.disconnect();
    }
}
