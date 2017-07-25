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
public class AskOTADialog {

    private Dialog dialog;
    private TextView msgTextView;
    private Button btn_positive;
    private Button btn_negative;
    Activity context;
    private AskOTADialogCallback askOTADialogCallback;

    public AskOTADialog(Activity context,AskOTADialogCallback askOTADialogCallback,String left,String right){
        this.context = context;
        this.askOTADialogCallback = askOTADialogCallback;
        init(context,left,right);
    }



    void init(final Activity context,String left,String right){
        LayoutInflater layoutInflater = LayoutInflater.from(context);
        View contentView = layoutInflater.inflate(R.layout.dialog_ask_ota, null);

        msgTextView = (TextView) contentView.findViewById(R.id.dialog_ask_ota_msg);
        btn_positive=(Button) contentView.findViewById(R.id.btn_positive);
        btn_positive.setText(left);
        btn_negative= (Button) contentView.findViewById(R.id.btn_negative);
        btn_negative.setText(right);
        btn_positive.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                askOTADialogCallback.positive();
                dismiss();
            }
        });
        btn_negative.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                askOTADialogCallback.negative();
                dismiss();
            }
        });

        dialog = new Dialog(context,R.style.MyAlertDialog2);
        dialog.setContentView(contentView);
        dialog.setCanceledOnTouchOutside(false);

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


    public interface AskOTADialogCallback{
        void positive();
        void negative();
    }

}
