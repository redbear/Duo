package net.redbear.redbearduo.view.Activity;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.Toast;

import net.redbear.module.ota.LocalFileManage;
import net.redbear.redbearduo.R;
import net.redbear.redbearduo.presenter.DeviceScanPresenter;
import net.redbear.taskmap.DuoTaskObservable;

import java.util.ArrayList;

import net.redbear.redbearduo.view.adapter.DevicesListRecyclerViewAdapter;
import net.redbear.redbearduo.data.device.Device;
import net.redbear.view.dialog.DownLoadFirmwareDialog;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

import static net.redbear.redbearduo.view.Activity.MApplication.setSharePreferencesData;

/**
 * Created by Dong on 16/1/4.
 */
public class DevicesScan extends Activity implements DeviceScanPresenter.DeviceScanPresenterCallBack,View.OnClickListener,DownLoadFirmwareDialog.OnCheckVersionCallback {

    @Bind(R.id.activity_main_swipe_refresh_layout)
    SwipeRefreshLayout mSwipeRefreshLayout;
    @Bind(R.id.activity_main_recyclerview)
    RecyclerView mRecyclerView;
    @Bind(R.id.heart_title)
    TextView heart;
    @Bind(R.id.warning_task)
    View warning_task;

    DevicesListRecyclerViewAdapter mDevicesListRecyclerViewAdapter;


    @Bind(R.id.device_scan_refresh_note)
    TextView refreshNote;

    DeviceScanPresenter deviceScanPresenter;
    private static final int SCANTIME = 5000;

    boolean gotoWifiActivity;
    @Bind(R.id.device_scan_menu)
    ImageView menuImage;
    PopupWindow menu;
    boolean isMenuOpen;
    DownLoadFirmwareDialog downLoadFirmwareDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ButterKnife.bind(this);
        warning_task.setOnClickListener(this);



//        if (MApplication.doNext == MApplication.WIFI_PROVISION){
//            startActivity(new Intent(this, ProvisionMainActivity.class));
//            MApplication.getMApplication().duoTaskObservable.addTask(Step.WIFI_PROVISION);
//        }else if(MApplication.doNext == MApplication.WIFI_CONTROLLER){
//            MApplication.getMApplication().duoTaskObservable.addTask(Step.WIFI_CONTROLLER);
//        }else if(MApplication.doNext == MApplication.BLE_SCAN){
//           // MApplication.getMApplication().duoTaskObservable.nextTask(Step.BLE_IS_NOT_ON);
//        }
        deviceScanPresenter = new DeviceScanPresenter(this);
        deviceScanPresenter.setDeviceScanPresenterCallBack(this);
        deviceScanPresenter.setTitleView(heart);
        initView();
        if (!MApplication.haveNewVersionFLG){
            menuImage.setImageDrawable(getResources().getDrawable(R.drawable.menu));
        }else {
            menuImage.setImageDrawable(getResources().getDrawable(R.drawable.menu_update_warning));
        }
    }

    private void initView(){
        mRecyclerView.setItemAnimator(new DefaultItemAnimator());
        final LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        mRecyclerView.setLayoutManager(layoutManager);

        mSwipeRefreshLayout.setColorSchemeResources(R.color.red, R.color.orange, R.color.blue);
        mSwipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                refreshNote.setVisibility(View.GONE);
                deviceScanPresenter.deviceScan(SCANTIME);
            }
        });
        mDevicesListRecyclerViewAdapter = new DevicesListRecyclerViewAdapter(this,new ArrayList<Device>(),deviceScanPresenter.connectState);
        mDevicesListRecyclerViewAdapter.setOnItemClickLitener(new DevicesListRecyclerViewAdapter.OnItemClickLitener() {
            @Override
            public void onItemClick(View view, int position) {
                Log.e("connect device", "-----------" + position);
                deviceScanPresenter.connectDevice(position);
            }
        });
        mRecyclerView.setAdapter(mDevicesListRecyclerViewAdapter);
    }

    @Override
    protected void onStart() {
        super.onStart();
        deviceScanPresenter.notifyCommunicationState();
        gotoWifiActivity = false;
    }


    @Override
    protected void onDestroy() {
        deviceScanPresenter.activityDestroy();
        super.onDestroy();
    }

    private void setupAdapter(ArrayList<Device> devices) {
        mDevicesListRecyclerViewAdapter.setDevices(devices);
    }

    @Override
    public void scanFinish(ArrayList<Device> devices) {
        Log.e("scanFinish",devices+"    "+devices.size());
        if (devices == null || devices.size() == 0){
            refreshNote.setVisibility(View.VISIBLE);
        }else {
            refreshNote.setVisibility(View.GONE);
        }
        setupAdapter(devices);
        mSwipeRefreshLayout.setRefreshing(false);
    }



    @Override
    public void scan() {
        warning_task.setVisibility(View.GONE);
        mSwipeRefreshLayout.post(new Runnable() {
            @Override
            public void run() {
                mSwipeRefreshLayout.setRefreshing(true);
            }
        });
    }



    @Override
    public void wifi_ble_disable() {
        warning_task.setVisibility(View.VISIBLE);
    }

    public void task_map(View view){
        Log.e("task map...........", DuoTaskObservable.getInstance().toString());
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.update:
                downLoadFirmwareDialog = new DownLoadFirmwareDialog(this,this);
                downLoadFirmwareDialog.verifyVersion();
                menu.dismiss();
                isMenuOpen = false;
                break;
            case R.id.about:
                menu.dismiss();
                isMenuOpen = false;
                startActivity(InfoActivity.getInfoActivityIntent(this));
                break;
        }
    }

    @OnClick(R.id.device_scan_menu)
    void menu(View view){
        if (menu == null){
            View contentView = getLayoutInflater().inflate(R.layout.menu_setting,null);
            menu = new PopupWindow(contentView,
                    ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, false);
            contentView.findViewById(R.id.update).setOnClickListener(this);
            menu.setOutsideTouchable(true);
            menu.setBackgroundDrawable(new BitmapDrawable());
            contentView.findViewById(R.id.about).setOnClickListener(this);
        }

        if (isMenuOpen){
            Log.e("menu","dimiss>>>>>>>>>");
            menu.dismiss();
            isMenuOpen = false;
            return;
        }

        if (!MApplication.haveNewVersionFLG){
            ((TextView)menu.getContentView().findViewById(R.id.update_text)).setText("Check Update");
            menu.getContentView().findViewById(R.id.update_text_available).setVisibility(View.GONE);
        }else {
            ((TextView)menu.getContentView().findViewById(R.id.update_text)).setText("Update Available");
            menu.getContentView().findViewById(R.id.update_text_available).setVisibility(View.VISIBLE);
        }

        Log.e("menu","show>>>>>>>>>");
        isMenuOpen = true;
        menu.showAsDropDown(view);
    }

    @Override
    public void checkFail() {
        downLoadFirmwareDialog.dismiss();
    }

    @Override
    public void downloadFinish() {
        MApplication.haveNewVersionFLG = false;
        menuImage.setImageDrawable(getResources().getDrawable(R.drawable.menu));
    }

    @Override
    public void cancelDownloadFirmware() {
        MApplication.haveNewVersionFLG = true;
    }

    @Override
    public void getDistanceVersion(String distanceVersion) {
        setSharePreferencesData(MApplication.appname, MApplication.sharePreferences_duo_firmware_version, distanceVersion);

        if (distanceVersion.compareToIgnoreCase(new LocalFileManage().getLocalFirmwareVersion()) > 0 ){
            downLoadFirmwareDialog.gotoStep2(distanceVersion);
        }else {
            MApplication.haveNewVersionFLG = false;
            downLoadFirmwareDialog.dismiss();
            Toast.makeText(DevicesScan.this,"No Updates Available",Toast.LENGTH_LONG).show();
        }
    }
}
