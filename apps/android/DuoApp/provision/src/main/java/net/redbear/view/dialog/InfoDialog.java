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
public class InfoDialog {

    private Dialog dialog;
    private TextView duoIPTextView,gatewayIPTextView,gatewayMacTextView,getGatewaySSIDTextView;
    private Button ok;
    Activity context;

    public InfoDialog(Activity context){
        this.context = context;
        init(context);
    }



    void init(final Activity context){
        LayoutInflater layoutInflater = LayoutInflater.from(context);
        View contentView = layoutInflater.inflate(R.layout.dialog_info, null);

        duoIPTextView = (TextView) contentView.findViewById(R.id.dialog_info_ip);
        gatewayIPTextView = (TextView) contentView.findViewById(R.id.dialog_info_gateway_ip);
        gatewayMacTextView = (TextView) contentView.findViewById(R.id.dialog_info_gateway_mac);
        getGatewaySSIDTextView = (TextView) contentView.findViewById(R.id.dialog_info_gateway_ssid);
        ok = (Button) contentView.findViewById(R.id.dialog_info_ok);
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
        lp.width = WindowManager.LayoutParams.WRAP_CONTENT;;
        lp.height = WindowManager.LayoutParams.WRAP_CONTENT;;
        dialogWindow.setAttributes(lp);
    }



    public void show(String duoIP,String gatewayIP,String gateway_mac,String gateWaySSID){
        duoIPTextView.setText(duoIP);
        gatewayIPTextView.setText(gatewayIP);
        gatewayMacTextView.setText(gateway_mac);
        getGatewaySSIDTextView.setText(gateWaySSID);
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
