package net.redbear.redbearduo.view.Activity;

import android.animation.ObjectAnimator;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.BounceInterpolator;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import net.redbear.module.ota.LocalFileManage;
import net.redbear.redbearduo.R;
import net.redbear.redbearduo.data.communication.wifi.DuoWifiUtils;
import net.redbear.view.dialog.DownLoadFirmwareDialog;
import static net.redbear.redbearduo.view.Activity.MApplication.*;


import butterknife.Bind;
import butterknife.ButterKnife;


/**
 * Created by Dong on 15/12/29.
 */
public class Splash_zero extends Activity implements DownLoadFirmwareDialog.OnCheckVersionCallback {

    private static final int delayTime = 3000;

    @Bind(R.id.splash_zero_imageView)
    ImageView icon;
    @Bind(R.id.splash_company_name)
    TextView companyName;

    DownLoadFirmwareDialog downLoadFirmwareDialog;
    private int backFlg = 0;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash_init);
        ButterKnife.bind(this);

        if(DuoWifiUtils.wifi_check_support() && DuoWifiUtils.network_is_on()){
            downLoadFirmwareDialog = new DownLoadFirmwareDialog(this,this);
            downLoadFirmwareDialog.verifyVersion();
        }else {
            checkHaveNewFirmwareVInLocal();
            settingInitFinish();
        }
    }


    private void settingInitFinish(){
        Log.e("Splash_zero","settingInitFinish >>>>>>>>>>>>>>>>>>");
        companyName.setVisibility(View.VISIBLE);
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                Intent intent;
                intent = new Intent(Splash_zero.this,DevicesScan.class);
                startActivity(intent);
                finish();
            }
        }, delayTime);

        Animation am = AnimationUtils.loadAnimation(this, R.anim.scale_fade_in);
        am.setInterpolator(new BounceInterpolator());
        companyName.setAnimation(am);
        am.start();

    }

    private void checkHaveNewFirmwareVInLocal(){
        String localxml = getSharePreferencesVersionStringData(MApplication.appname, MApplication.sharePreferences_duo_firmware_version);
        if (localxml.compareToIgnoreCase(new LocalFileManage().getLocalFirmwareVersion()) > 0 ){
            MApplication.getMApplication().haveNewVersionFLG = true;
        }
    }

    @Override
    public void checkFail() {
        Log.e("Splash_zero","checkFail");
        checkHaveNewFirmwareVInLocal();
        downLoadFirmwareDialog.dismiss();
        settingInitFinish();
    }

    @Override
    public void downloadFinish() {
        MApplication.haveNewVersionFLG = false;
        settingInitFinish();
    }

    @Override
    public void cancelDownloadFirmware() {
        Log.e("Splash_zero","cancelDownloadFirmware");
        MApplication.haveNewVersionFLG = true;
        settingInitFinish();
    }

    @Override
    public void getDistanceVersion(String distanceVersion) {
        Log.e("Splash_zero", "getDistanceVersion " + distanceVersion);
        setSharePreferencesData(MApplication.appname, MApplication.sharePreferences_duo_firmware_version, distanceVersion);

        if (distanceVersion.compareToIgnoreCase(new LocalFileManage().getLocalFirmwareVersion()) > 0 ){
            downLoadFirmwareDialog.gotoStep2(distanceVersion);
        }else {
            MApplication.haveNewVersionFLG = false;
            downLoadFirmwareDialog.dismiss();
            settingInitFinish();
        }
    }




//    @Override
//    public void onBackPressed() {
//        //super.onBackPressed();
//        if (backFlg > 0){
//            finish();
//        }else {
//            Toast.makeText(this,"Double click to close the App",Toast.LENGTH_SHORT).show();
//            backFlg++;
//            new Handler().postDelayed(new Runnable() {
//                @Override
//                public void run() {
//                    backFlg = 0;
//                }
//            }, 2000);
//        }
//
//    }

    public boolean onKeyDown(int keyCode, KeyEvent event) {
        // TODO Auto-generated method stub
        if(keyCode==KeyEvent.KEYCODE_BACK&&event.getRepeatCount()==0){
            Toast.makeText(this,"Double click to close the App",Toast.LENGTH_SHORT).show();
            return true;
        }
        if (keyCode == KeyEvent.KEYCODE_SEARCH)
        {
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }



}
