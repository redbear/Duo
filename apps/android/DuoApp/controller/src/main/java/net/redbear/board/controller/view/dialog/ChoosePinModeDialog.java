package net.redbear.board.controller.view.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;

import net.redbear.board.controller.R;
import net.redbear.board.controller.model.product.Common;

import java.util.ArrayList;

/**
 * Created by dong on 3/23/16.
 */
public class ChoosePinModeDialog {
    private Activity context;
    private Dialog dialog;
    private TextView titleTextView;
    private ListView listView;
    private ArrayList<Integer> pinModeSupport;
    private OnPinModeSelectCallback callback;
    private int pin;

    public ChoosePinModeDialog(Activity context){
        this.context = context;
        init(context);
    }


    void init(final Activity context){
        LayoutInflater layoutInflater = LayoutInflater.from(context);
        View contentView = layoutInflater.inflate(R.layout.dialog_pinmode_choose, null);

        titleTextView = (TextView) contentView.findViewById(R.id.dialog_pinmode_choose_title);
        titleTextView.setText("title");

        listView = (ListView) contentView.findViewById(R.id.dialog_pinmode_choose_listView);
        listView.setOnItemClickListener(clickListener);

        dialog = new Dialog(context,R.style.MyAlertDialog);
        dialog.setContentView(contentView);

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
        lp.width = (int)(0.7*width);
        lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
        dialogWindow.setAttributes(lp);
    }

    public void show(String title,ArrayList<Integer> pinModeSupport,int pin){
        if (dialog != null && !dialog.isShowing() && context!= null){
            titleTextView.setText("Pin "+title);
            this.pinModeSupport = pinModeSupport;
            this.pin = pin;
            PinModeAdapter adapter = new PinModeAdapter();
            listView.setAdapter(adapter);
            dialog.show();
        }
    }

    public void dismiss(){
        if (dialog != null && dialog.isShowing()){
            dialog.dismiss();
        }
    }

    public void setPinModeSupport(ArrayList<Integer> pinModeSupport) {
        this.pinModeSupport = pinModeSupport;
    }

    private AdapterView.OnItemClickListener clickListener = new AdapterView.OnItemClickListener() {
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            if (callback != null)
                callback.callback(pin,pinModeSupport.get(position));
            dismiss();
        }
    };

    public void setCallback(OnPinModeSelectCallback callback) {
        this.callback = callback;
    }

    private class PinModeAdapter extends BaseAdapter{

        @Override
        public int getCount() {
            return pinModeSupport.size();
        }

        @Override
        public Object getItem(int position) {
            return position;
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            if (convertView == null){
                convertView = LayoutInflater.from(context).inflate(R.layout.adapter_pinmode,null);
            }
            TextView textView = (TextView) convertView.findViewById(R.id.adapter_pinmode_textView);
            textView.setText(Common.getStringByPinMode(pinModeSupport.get(position)));
            return convertView;
        }
    }



}
