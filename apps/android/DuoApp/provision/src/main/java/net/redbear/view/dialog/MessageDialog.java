package net.redbear.view.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;

import net.redbear.bleprovision.R;


/**
 * Created by Dong on 15/10/28.
 */
public class MessageDialog {

    private Dialog dialog;
    private TextView msgTextView;
    private Button ok;
    Activity context;

    public MessageDialog(Activity context){
        this.context = context;
        init(context);
    }



    void init(final Activity context){
        LayoutInflater layoutInflater = LayoutInflater.from(context);
        View contentView = layoutInflater.inflate(R.layout.dialog_message, null);

        msgTextView = (TextView) contentView.findViewById(R.id.dialog_msg);
        ok = (Button) contentView.findViewById(R.id.dialog_msg_ok);
        ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
                context.finish();
            }
        });

        dialog = new Dialog(context,R.style.MyAlertDialog2);
        dialog.setContentView(contentView);
        dialog.setCanceledOnTouchOutside(false);
        dialog.setCancelable(false);

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
        //lp.width = WindowManager.LayoutParams.WRAP_CONTENT;
        lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
        dialogWindow.setAttributes(lp);
    }



    public void show(String msg){
        msgTextView.setText(msg);
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
