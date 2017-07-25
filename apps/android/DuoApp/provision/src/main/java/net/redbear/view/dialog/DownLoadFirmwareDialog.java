package net.redbear.view.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.os.Environment;
import android.support.v4.view.PagerAdapter;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;

import net.redbear.bleprovision.R;
import net.redbear.module.downloader.DuoFirmwareVersionInfo;
import net.redbear.module.downloader.FileDownloader;
import net.redbear.module.downloader.JsonClassDownloader;
import net.redbear.module.ota.LocalFileManage;
import net.redbear.view.MyViewPager;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import rx.Observable;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;


/**
 * Created by Dong on 15/10/28.
 */
public class DownLoadFirmwareDialog {

    private Dialog dialog;
    private MyViewPager viewPager;
    Activity context;
    private Button btn_positive;
    private Button btn_negative;
    private ProgressBar downloadProgressBar;
    private TextView downloadProgressText;
    private TextView step_2_text;
    private OnCheckVersionCallback onCheckVersionCallback;
    DuoFirmwareVersionInfo duoFirmwareVersionInfo;

    public DownLoadFirmwareDialog(Activity context, OnCheckVersionCallback onCheckVersionCallback){
        this.context = context;
        init(context);
        this.onCheckVersionCallback = onCheckVersionCallback;
    }

    void init(final Activity context){
        LayoutInflater layoutInflater = LayoutInflater.from(context);
        View contentView = layoutInflater.inflate(R.layout.dialog_download_firmware, null);

        viewPager = (MyViewPager) contentView.findViewById(R.id.dialog_download_firmware_viewPager);
        viewPager.setScrollble(false);

        LayoutInflater lf = context.getLayoutInflater().from(context);

        ArrayList<View> viewList = new ArrayList<>();// 将要分页显示的View装入数组中
        viewList.add(lf.inflate(R.layout.view_pager_oat_render_version, null));
        viewList.add(lf.inflate(R.layout.view_pager_oat_ask_to_download, null));
        viewList.add(lf.inflate(R.layout.view_pager_oat_loadiong, null));
        viewPager.setAdapter(new ViewPagerAdapter(viewList));

        dialog = new Dialog(context,R.style.MyAlertDialog3);
        dialog.setContentView(contentView);
        dialog.setCanceledOnTouchOutside(false);
        dialog.setCancelable(false);


        step_2_text = (TextView) viewList.get(1).findViewById(R.id.ota_2_text);

        btn_positive=(Button) viewList.get(1).findViewById(R.id.btn_positive);
        btn_negative= (Button) viewList.get(1).findViewById(R.id.btn_negative);
        btn_positive.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                update_firmware();
                viewPager.setCurrentItem(2);
            }
        });
        btn_negative.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onCheckVersionCallback != null)
                    onCheckVersionCallback.cancelDownloadFirmware();
                dismiss();
            }
        });

        downloadProgressBar = (ProgressBar) viewList.get(2).findViewById(R.id.dialog_ota_progressBar);
        downloadProgressBar.setMax(100);
        downloadProgressText = (TextView) viewList.get(2).findViewById(R.id.dialog_ota_progress_value);

        Window dialogWindow = dialog.getWindow();
        dialogWindow.setGravity(Gravity.CENTER);
        dialogWindow.setWindowAnimations(R.style.wheelDialogAnimation);


        WindowManager.LayoutParams lp = dialogWindow.getAttributes();

        DisplayMetrics metric = new DisplayMetrics();
        context.getWindowManager().getDefaultDisplay().getMetrics(metric);
        int width = metric.widthPixels;
        int height = metric.heightPixels;
        Log.e("window","width :"+width+" height :"+height);

        lp.x = 0;
        lp.y = 0;
        lp.width = (int)(width*0.8);
        //lp.height = (int)(height*0.4);
//        lp.width = WindowManager.LayoutParams.WRAP_CONTENT;
        lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
        dialogWindow.setAttributes(lp);
    }

    public void verifyVersion(){
        show();
        ota_check_version();
    }

    public String getVersion(){
        return new LocalFileManage().getLocalFirmwareVersion();
    }

    public void show(){
        if (dialog != null && !dialog.isShowing() && context!= null){
            dialog.show();
        }
    }

    public void dismiss(){
        if (dialog != null && dialog.isShowing()){
            dialog.dismiss();
        }
    }

    private void ota_check_version(){
        Observable.create(new Observable.OnSubscribe<String>() {
            @Override
            public void call(final Subscriber<? super String> subscriber) {
                JsonClassDownloader<DuoFirmwareVersionInfo> downloader = new JsonClassDownloader<>();
                downloader.download("https://raw.githubusercontent.com/redbear/Duo/master/firmware/latest.json", new JsonClassDownloader.OnDataCallback<DuoFirmwareVersionInfo>() {
                    @Override
                    public void getData(DuoFirmwareVersionInfo duoFirmwareVersionInfo) {
                        Log.e("get json", duoFirmwareVersionInfo.toString());
                        DownLoadFirmwareDialog.this.duoFirmwareVersionInfo = duoFirmwareVersionInfo;
                        subscriber.onNext(duoFirmwareVersionInfo.getFirmwareVersion());
                        subscriber.onCompleted();
                    }

                    @Override
                    public void getDataFail(Exception e) {
                        subscriber.onError(e);
                    }
                }, DuoFirmwareVersionInfo.class);
            }
        })
                .retry(2)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<String>() {
                    @Override
                    public void onCompleted() {
                    }
                    @Override
                    public void onError(Throwable e) {
                        Log.e("get json version erro",e.toString());
                        if (onCheckVersionCallback != null)
                            onCheckVersionCallback.checkFail();
                    }
                    @Override
                    public void onNext(String s) {
                        if (onCheckVersionCallback != null)
                            onCheckVersionCallback.getDistanceVersion(s);
                    }
                });
    }

    public void gotoStep2(String version){
        viewPager.setCurrentItem(1);
        step_2_text.setText("There is a new firmware (" + version + ").Would you like to download?\n"+"Size :"+duoFirmwareVersionInfo.getFirmwareSize()+"Kb");
    }

    private void update_firmware(){
        LocalFileManage.clearDir();
        new Thread(new Runnable() {
            @Override
            public void run() {
                downloadFirmware();
            }
        }).start();
    }

    private void downloadFirmware(){
        FileDownloader downloader = new FileDownloader();
        downloader.download(duoFirmwareVersionInfo.getFirmwareURL(), new FileDownloader.OnDataCallback() {
                    @Override
                    public void getData(InputStream inputStream, final int len) {
                        FileOutputStream output = null;

                        String pathName = LocalFileManage.filePath + duoFirmwareVersionInfo.getFileName();//文件存储路径
                        try {
                            File file = new File(pathName);
                            if (file.exists()) {
                                Log.e("file", "exits");
                                return;
                            } else {
                                file = new File(pathName+"7");

                                Log.e("file", "file name :  "+file.getName());
                                output = new FileOutputStream(file);
                                //读取大文件
                                byte[] buffer = new byte[4 * 1024];
                                long receiveLen = 0;
                                int readLen = -1;
                                while ((readLen = inputStream.read(buffer)) != -1) {
                                    receiveLen += readLen;
                                    //Log.e("receive data", "readLen :" + readLen + " receiveLen :" + receiveLen + "total len" + len + " -- progress :" + receiveLen * 100.0 / len + "%");
                                    final long finalReceiveLen = receiveLen;
                                    context.runOnUiThread(new Runnable() {
                                        @Override
                                        public void run() {
                                            downloadProgressBar.setProgress((int) (finalReceiveLen * 100.0 / len));
                                            downloadProgressText.setText(downloadProgressBar.getProgress()+"% done");
                                        }
                                    });
                                    output.write(buffer, 0, readLen);
                                }
                                LocalFileManage.upZipFile(file,LocalFileManage.filePath);
                                context.runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        dismiss();
                                        if (onCheckVersionCallback != null)
                                            onCheckVersionCallback.downloadFinish();
                                    }
                                });

                                Log.e("file", "rename :  " + file.renameTo(new File(pathName)));
                                output.flush();
                                output.close();
                                inputStream.close();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            Log.e("file", "Exception................."+e);
                        } finally {
                            try {
                                output.close();
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                    @Override
                    public void getDataFail (Exception e){

                    }
                }
        );
    }

    class ViewPagerAdapter extends PagerAdapter {

        private List<View> list = null;

        public ViewPagerAdapter(List<View> list) {
            this.list = list;
        }

        @Override
        public int getCount() {
            return list.size();
        }

        @Override
        public Object instantiateItem(ViewGroup container, int position) {
            container.addView(list.get(position));
            return list.get(position);
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            container.removeView(list.get(position));
        }

        @Override
        public boolean isViewFromObject(View arg0, Object arg1) {
            return arg0 == arg1;
        }

    }

    public interface OnCheckVersionCallback{
        void checkFail();
        void downloadFinish();
        void cancelDownloadFirmware();
        void getDistanceVersion(String version);
    }
}
