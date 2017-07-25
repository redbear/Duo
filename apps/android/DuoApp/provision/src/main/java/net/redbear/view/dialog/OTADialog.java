package net.redbear.view.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.support.v4.view.PagerAdapter;
import android.text.method.ScrollingMovementMethod;
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
import android.widget.ScrollView;
import android.widget.TextView;

import net.redbear.bleprovision.R;
import net.redbear.module.ota.LocalFileManage;
import net.redbear.view.MyViewPager;

import java.util.ArrayList;
import java.util.List;

import rx.Observable;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;


/**
 * Created by Dong on 15/10/28.
 */
public class OTADialog {

    private Dialog dialog;
    Activity context;
    private ProgressBar otaProgressBar;
    private TextView otaProgressTextLeft;
    private TextView otaProgressTextRight;
    private TextView otaLog;
    ScrollView mScrollView;

    public OTADialog(Activity context){
        this.context = context;
        init(context);
    }


    void init(final Activity context){
        LayoutInflater layoutInflater = LayoutInflater.from(context);
        View contentView = layoutInflater.inflate(R.layout.dialog_ota, null);

        dialog = new Dialog(context,R.style.MyAlertDialog2);
        dialog.setContentView(contentView);
        dialog.setCanceledOnTouchOutside(false);

        otaProgressBar = (ProgressBar) contentView.findViewById(R.id.dialog_ota_progress_bar);
        otaProgressBar.setMax(100);
        otaProgressTextLeft = (TextView) contentView.findViewById(R.id.dialog_ota_progress_info_left);
        otaProgressTextRight = (TextView) contentView.findViewById(R.id.dialog_ota_progress_info_right);
        otaLog = (TextView) contentView.findViewById(R.id.dialog_ota_progress_log);
        //otaLog.setMovementMethod(new ScrollingMovementMethod());
        mScrollView = (ScrollView) contentView.findViewById(R.id.SCROLLER_ID);



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
        lp.width = (int)(width*0.7);
        lp.height = (int)(height*0.3);
//        lp.width = WindowManager.LayoutParams.WRAP_CONTENT;
//        lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
        dialogWindow.setAttributes(lp);
    }



    private void scrollToBottom()
    {
        mScrollView.post(new Runnable()
        {
            public void run()
            {
                mScrollView.smoothScrollTo(0, otaLog.getBottom());
            }
        });
    }



    public void addLog(String log,int progress,int task_n){
        if (log != null){
            scrollToBottom();
            otaLog.setText(otaLog.getText().toString()+log+"\n");
        }
        if (!otaProgressTextRight.getText().toString().equals(task_n+"/2")){
            otaProgressTextRight.setText(task_n+"/2");
        }
        if (progress >= 0){
            otaProgressBar.setProgress(progress);
            otaProgressTextLeft.setText(progress+"% "+"Done");
        }
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
}
