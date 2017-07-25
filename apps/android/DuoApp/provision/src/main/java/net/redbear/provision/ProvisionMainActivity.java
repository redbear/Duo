package net.redbear.provision;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextPaint;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import net.redbear.bleprovision.R;
import net.redbear.module.communicate.DuoIPInfo;
import net.redbear.module.communicate.ble.BLEUtils;

import java.util.List;

import net.redbear.module.communicate.AP;
import net.redbear.module.communicate.CommunicateCallBack;
import net.redbear.view.adapter.DevicesListRecyclerViewAdapter;
import net.redbear.view.dialog.AskOTADialog;
import net.redbear.view.dialog.InfoDialog;
import net.redbear.view.dialog.LoadingDialog;
import net.redbear.view.dialog.MessageDialog;
import net.redbear.view.dialog.OTADialog;

/**
 * Created by Dong on 15/12/28.
 */
public class ProvisionMainActivity extends Activity{
    private ProvisionPresenter provisionPresenter;

    public static String getExtraBLEString(){
        return "bluetoothdevice";
    }
    public static String getExtraWifiString(){
        return "wifidevice";
    }

    LoadingDialog msgDialog;
    OTADialog otaDialog;
    SwipeRefreshLayout mSwipeRefreshLayout;
    RecyclerView mRecyclerView;
    DevicesListRecyclerViewAdapter mDevicesListRecyclerViewAdapter;
    TextView step;

    private static final int DUO_CONNECT_AP_TIMEOUT = 60000;
    private boolean isConnecting,connect;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_provision_main);
        //dependent on which way to provision(ble/wifi)
        provisionPresenter = new ProvisionPresenter(this,getIntent(),communicateCallBack);
        initView();
        msgDialog = new LoadingDialog(ProvisionMainActivity.this,"connect to duo");
        msgDialog.show();

    }


    private void initView(){
        //title
        ((TextView)findViewById(R.id.bar_title)).setText(provisionPresenter.getDeviceName());
        if (provisionPresenter.isBLEProvision){
            ((ImageView)findViewById(R.id.bar_connect_mode_imageView)).setImageDrawable(getResources().getDrawable(R.drawable.ble_icon));
        }else {
            ((ImageView)findViewById(R.id.bar_connect_mode_imageView)).setImageDrawable(getResources().getDrawable(R.drawable.wifi_icon));
        }


        mRecyclerView = (RecyclerView) findViewById(R.id.provision_ap_recycler);
        mRecyclerView.setItemAnimator(new DefaultItemAnimator());
        final LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        mRecyclerView.setLayoutManager(layoutManager);
        mDevicesListRecyclerViewAdapter = new DevicesListRecyclerViewAdapter(this);
        mDevicesListRecyclerViewAdapter.setOnItemClickListener(new DevicesListRecyclerViewAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                AP ap = mDevicesListRecyclerViewAdapter.getItem(position);
                if (ap == null)
                    return;
                provisionPresenter.connect(ap);
            }
        });
        mRecyclerView.setAdapter(mDevicesListRecyclerViewAdapter);


        mSwipeRefreshLayout = (SwipeRefreshLayout) findViewById(R.id.provision_ap_listView);
        mSwipeRefreshLayout.setColorSchemeResources(R.color.red, R.color.orange, R.color.blue);
        mSwipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                provisionPresenter.scan();
                mDevicesListRecyclerViewAdapter.clean();
            }
        });

        findViewById(R.id.bar_back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                provisionPresenter.disconnect();
                finish();
            }
        });

        step = (TextView) findViewById(R.id.provision_step_textView);
        TextPaint tp = step.getPaint();
        tp.setFakeBoldText(true);
        step.setText("Pull to refresh");
    }

    CommunicateCallBack communicateCallBack = new CommunicateCallBack() {

        @Override
        public void onConnectToDuo() {
            Log.e(".......", "XXXXXXX onConnectToDuo");
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    msgDialog.dismiss();
                }
            });
            provisionPresenter.getVersion();
        }

        @Override
        public void onConnectTimeout() {
            Log.e(".......", "XXXXXXX onConnectTimeout");

            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    msgDialog.dismiss();
                    createDialog("connect to Duo timeout");
                }
            });
        }

        @Override
        public void onDisconnectFromDuo(final String msg) {
            Log.e(".......", "XXXXXXX onDisconnectFromDuo");
            if (connect)
                return;
            createDialog("Disconnect to Duo");
        }

        @Override
        public void onGetFirmVersion(String v) {
            Log.e(".......", "XXXXXXX onGetFirmVersion");
            Log.e("version", v);
            final String hv= provisionPresenter.verifyVersion(v);
            if (hv.length() > 0){
                if (provisionPresenter.isBLEProvision){
                    AskOTADialog askOTADialog = new AskOTADialog(ProvisionMainActivity.this, new AskOTADialog.AskOTADialogCallback() {
                        @Override
                        public void positive() {
                            BLEUtils.closeBluetooth(ProvisionMainActivity.this);
                            finish();
                        }

                        @Override
                        public void negative() {
                            scan();
                        }
                    },"Upgrade","Cancel");
                    askOTADialog.show("There is a newer firmware (v" + hv + ") for your Duo (" + v + "),do you want to upgrade now ?\n\nIf upgrade,you need to open wifi and bluetooth will close.");
                }else {
                    AskOTADialog askOTADialog = new AskOTADialog(ProvisionMainActivity.this, new AskOTADialog.AskOTADialogCallback() {
                        @Override
                        public void positive() {
                            otaDialog = new OTADialog(ProvisionMainActivity.this);
                            otaDialog.show();
                            provisionPresenter.ota(hv);
                        }

                        @Override
                        public void negative() {
                            scan();
                        }
                    },"Upgrade","Cancel");
                    askOTADialog.show("There is a newer firmware(v" + hv + ") for your Duo(v" + v + "),do you want to upgrade now ?");
                }
            }else {
                scan();
            }
        }

        @Override
        public void onScanning() {
            Log.e(".......", "XXXXXXX onScanning");
        }

        @Override
        public void onOTALogBack(final String log, final int progress, final int task_n) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (otaDialog == null)
                        return;
                    otaDialog.addLog(log, progress, task_n);
                }
            });
        }

        @Override
        public void onOTAFinish() {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (otaDialog == null)
                        return;
                    otaDialog.dismiss();
                    msgDialog.show("check whether Duo have WifiProfile");
                }
            });
            provisionPresenter.checkDeviceHaveWifiProfile();
        }

        @Override
        public void onOTAFail() {

        }

        @Override
        public void onScanComplete(final List<AP> aps) {
            Log.e(".......", "XXXXXXX onScanComplete");
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mDevicesListRecyclerViewAdapter.refreshData(aps);
                    mSwipeRefreshLayout.setRefreshing(false);
                    if (mDevicesListRecyclerViewAdapter.getItemCount() > 0){
                        step.setText("Pull to refresh or choose a AP to connect");
                    }else {
                        step.setText("Pull to refresh");
                    }
                }
            });
        }

        @Override
        public void onScanAnAP(final AP ap) {
            Log.e(".......", "XXXXXXX onScanAnAP");
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mRecyclerView.post(new Runnable() {
                        @Override
                        public void run() {
                            mDevicesListRecyclerViewAdapter.refreshData(ap);
                        }
                    });
                }
            });
        }

        @Override
        public void onConnecting() {
            Log.e(".......", "XXXXXXX onConnecting");
            isConnecting = true;
            connect = true;
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    msgDialog.show("Connecting");
                    new Handler().postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            if (isConnecting) {
                                createDialog("Duo connect to AP timeout!");
                            }
                        }
                    }, DUO_CONNECT_AP_TIMEOUT);
                }
            });

        }

        @Override
        public void onCheckDeviceHaveWifiProfile(final boolean have) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    msgDialog.dismiss();
                    if (have){
                        AskOTADialog askOTADialog = new AskOTADialog(ProvisionMainActivity.this, new AskOTADialog.AskOTADialogCallback() {
                            @Override
                            public void positive() {
                                scan();
                            }

                            @Override
                            public void negative() {
                                finish();
                            }
                        },"Yes","No");
                        askOTADialog.show("Do you want to provision again?");
                    }
                }
            });
        }

        @Override
        public void onConnectComplete(final DuoIPInfo duoIPInfo) {
            Log.e(".......", "XXXXXXX onConnectComplete");
            isConnecting = false;
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    msgDialog.dismiss();
                    if (duoIPInfo == null) {
                        connectStateNote();
                    } else {
                        new InfoDialog(ProvisionMainActivity.this).show(duoIPInfo.getDuoIP(),duoIPInfo.getGateWayIP(),duoIPInfo.getGateWayMAC(),duoIPInfo.getGateWaySSID());
                    }
                }
            });
        }

        @Override
        public void onBoardConnectToAPError(Exception e) {
            Log.e(".......", "XXXXXXX onBoardConnectToAPError");
            isConnecting = false;
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mRecyclerView.post(new Runnable() {
                        @Override
                        public void run() {
                            msgDialog.dismiss();
                            Toast.makeText(ProvisionMainActivity.this, "Connect To AP Error", Toast.LENGTH_SHORT).show();
                            connectStateNote();
                            finish();
                        }
                    });
                }
            });
            if (e != null){
                Log.e("communicateCallBack", e.getMessage());
            }
        }
    };


    private void createDialog(final String content){
        if (this.isDestroyed())
            return;
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                MessageDialog messageDialog = new MessageDialog(ProvisionMainActivity.this);
                messageDialog.show(content);
            }
        });
    }

    private void scan(){
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                provisionPresenter.scan();
                mSwipeRefreshLayout.setRefreshing(true);
            }
        });
    }

    private void connectStateNote(){
        ProvisionMainActivity.this.startActivity(new Intent(ProvisionMainActivity.this,DuoStateActivity.class));
        finish();
    }

    @Override
    protected void onDestroy() {
        provisionPresenter.disconnect();
        super.onDestroy();
    }
}
