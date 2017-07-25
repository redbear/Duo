package net.redbear.board.controller.view.activity;

import android.app.Activity;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import net.redbear.board.controller.R;
import net.redbear.board.controller.model.correspondent.CorrespondentDataCallback;
import net.redbear.board.controller.model.correspondent.DataPackage;
import net.redbear.board.controller.model.product.Common;
import net.redbear.board.controller.presenter.ControlActivityPresenter;
import net.redbear.board.controller.presenter.ControlActivityPresenterCallback;
import net.redbear.board.controller.view.customView.ControlView;
import net.redbear.board.controller.view.customView.PinViewCallback;
import net.redbear.board.controller.view.dialog.BarControlDialog;
import net.redbear.board.controller.view.dialog.ChoosePinModeDialog;
import net.redbear.board.controller.view.dialog.LoadingDialog;
import net.redbear.board.controller.view.dialog.OnBarControlCallback;
import net.redbear.board.controller.view.dialog.OnPinModeSelectCallback;

/**
 * Created by dong on 3/22/16.
 */
public class ControlActivity extends Activity implements PinViewCallback,OnPinModeSelectCallback,CorrespondentDataCallback,OnBarControlCallback{
    private static final String INTENT_NAME_FLG = "MDNS NAME";
    private static final String INTENT_IP_FLG   = "MDNS IP";
    private static final String INTENT_PORT_FLG = "MDNS PORT";
    private static final String INTENT_BLE_FLG = "BLE";

    public static Intent getIntent(Context context, String name, String ip, int port, BluetoothDevice ble){
        Intent intent = new Intent(context,ControlActivity.class);
        intent.putExtra(INTENT_NAME_FLG,name);
        intent.putExtra(INTENT_IP_FLG,ip);
        intent.putExtra(INTENT_PORT_FLG,port);
        intent.putExtra(INTENT_BLE_FLG,ble);
        return intent;
    }


    private ControlActivityPresenter controlActivityPresenter;


    //view
    ControlView controlView;
    ChoosePinModeDialog choosePinModeDialog;
    BarControlDialog controlDialog;
    LoadingDialog loadingDialog;
    View back;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_control);

        controlActivityPresenter = new ControlActivityPresenter(this,getIntent().getStringExtra(INTENT_IP_FLG),
                                                                getIntent().getIntExtra(INTENT_PORT_FLG,8888),
                                                                (BluetoothDevice) getIntent().getParcelableExtra(INTENT_BLE_FLG),
                                                                this);

        controlView = (ControlView) findViewById(R.id.control_activity_control_view);
        controlView.setCallback(this);
        controlView.post(new Runnable() {
            @Override
            public void run() {
                controlView.attachBoard(controlActivityPresenter.getBoard());
            }
        });

        back = findViewById(R.id.activity_control_head_back);
        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                controlActivityPresenter.destroy();
                finish();
            }
        });

        choosePinModeDialog = new ChoosePinModeDialog(this);
        choosePinModeDialog.setCallback(this);
        controlDialog = new BarControlDialog(this);
        controlDialog.setCallback(this);
        loadingDialog = new LoadingDialog(this);
        loadingDialog.show("Connecting");
    }


    @Override
    public void onPinClick(int num,int pinListNum) {
        Log.e("onPinClick",""+num);
        choosePinModeDialog.show(controlActivityPresenter.getBoard().getPin(pinListNum).getPinName(),
                                 controlActivityPresenter.getBoard().getPin(pinListNum).getSupportPinNumMode(),
                                 controlActivityPresenter.getBoard().getPin(pinListNum).getPinNum());
    }

    @Override
    public void onControlClick(int num,int pinListNum,int pinMode) {
        Log.e("connect","onControlClick 111  "+"  pinNum :"+num+"  pinMode :"+pinMode);
        if (Common.isBarControl(pinMode)){
            controlDialog.show(controlActivityPresenter.getBoard().getPin(pinListNum).getPinName(),   //pin name
                    pinMode,    //pin mode
                    controlActivityPresenter.getBoard().getPin(pinListNum).getPinNum(),               //pin num
                    controlActivityPresenter.getBoard().getPin(pinListNum).getValue(),               //pin value
                    0,                                                                        //min value
                    Common.getControlModeMaxValue(pinMode));                                //max value
        }else {
            int data = controlActivityPresenter.getBoard().getPin(pinListNum).getValue() > 0?0:1;
            controlActivityPresenter.getCorrespondent().setPinData(num,Common.changeToDuoPinMode(pinMode),data);
        }
    }

    @Override
    public void onResetAllClick() {
        controlActivityPresenter.getCorrespondent().resetAll();
    }

    @Override
    public void callback(int pin,int pinMode) {
        controlActivityPresenter.getCorrespondent().setPinMode(pin, Common.changeToDuoPinMode(pinMode));
    }

    @Override
    public void onConnectSuccess(final boolean isBLE) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (loadingDialog != null){
                    loadingDialog.dismiss();
                }
                controlView.setIcon(isBLE);
            }
        });
    }

    @Override
    public void onConnectFail() {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(ControlActivity.this,"connect fail",Toast.LENGTH_SHORT).show();
                finish();
            }
        });
    }

    @Override
    public void onDisconnect() {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(ControlActivity.this,"disconnect",Toast.LENGTH_SHORT).show();
                finish();
            }
        });
    }

    @Override
    public void onDataReceive(final DataPackage d) {
        if (d == null){
            Log.e("onDataReceive","DataPackage == null");
            return;
        }
        Log.e("onDataReceive",d.toString());
        if (d.getCommand().equals("R")){
            controlActivityPresenter.getBoard().resetAll();
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    controlView.resetAll();
                }
            });
        }else {
            controlActivityPresenter.getBoard().notifyPinData(d.getPin(),Common.getPinModeByDuoPinMode(d.getPinMode()),d.getData());
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    controlView.notifyPinData(controlActivityPresenter.getBoard().getPinViewNum(d.getPin()),Common.getPinModeByDuoPinMode(d.getPinMode()),d.getData());
                }
            });
        }
    }

    @Override
    public void onBarControlCallback(int pin, int pinMode, int data) {
        controlActivityPresenter.getCorrespondent().setPinData(pin,Common.changeToDuoPinMode(pinMode),data);
    }
}
