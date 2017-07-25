package net.redbear.board.controller.view.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ProgressBar;
import android.widget.TextView;

import net.redbear.board.controller.R;


/**
 * Created by Dong on 15/10/28.
 */
public class LoadingDialog {

    private Dialog dialog;
    private String content;
    TextView textView;
    Activity context;

    public LoadingDialog(Activity context, String content){
        this.content = content;
        this.context = context;
        init(context);
    }
    public LoadingDialog(Activity context){
        this.context = context;
        init(context);
    }



    void init(final Activity context){
        LayoutInflater layoutInflater = LayoutInflater.from(context);
        View contentView = layoutInflater.inflate(R.layout.dialog_loading, null);

        textView = (TextView) contentView.findViewById(R.id.dialog_loading_text);
        ((ProgressBar)contentView.findViewById(R.id.progressBar)).getIndeterminateDrawable().setColorFilter(context.getResources().getColor(R.color.colorPrimary), android.graphics.PorterDuff.Mode.MULTIPLY);
        if (content != null){
            textView.setText(content);
        }

        dialog = new Dialog(context, R.style.MyAlertDialog);
        dialog.setContentView(contentView);
        dialog.setCanceledOnTouchOutside(false);
        dialog.setCancelable(false);

        Window dialogWindow = dialog.getWindow();
        dialogWindow.setGravity(Gravity.CENTER);


        WindowManager.LayoutParams lp = dialogWindow.getAttributes();

        DisplayMetrics metric = new DisplayMetrics();
        context.getWindowManager().getDefaultDisplay().getMetrics(metric);
        int width = metric.widthPixels;
        int height = metric.heightPixels;
        Log.e("window","width :"+width+" height :"+height);

        lp.x = 0;
        lp.y = 0;
        lp.width = WindowManager.LayoutParams.WRAP_CONTENT;;
        lp.height = WindowManager.LayoutParams.WRAP_CONTENT;;
        dialogWindow.setAttributes(lp);
    }


    public void setText(String text){
        textView.setText(text);
    }

    public void show(String msg){
        textView.setText(msg);
        if (dialog != null && !dialog.isShowing() && context!= null){
            dialog.show();
        }
    }
    public void dismiss(){
        if (dialog != null && dialog.isShowing() && context != null && !context.isFinishing()){
            dialog.dismiss();
        }
    }

}
