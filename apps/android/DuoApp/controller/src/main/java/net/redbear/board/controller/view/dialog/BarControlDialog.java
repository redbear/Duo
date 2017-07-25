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
import android.widget.SeekBar;
import android.widget.TextView;

import net.redbear.board.controller.R;
import net.redbear.board.controller.model.product.Common;

import java.util.ArrayList;

/**
 * Created by dong on 3/23/16.
 */
public class BarControlDialog implements View.OnClickListener,SeekBar.OnSeekBarChangeListener{
    private Activity context;
    private Dialog dialog;
    private TextView titleTextView,modeTextView,valueTextView,minValueTextView,maxValueTextView;
    private View minusView,plusView;
    private SeekBar valueSeekBar;

    private int value;
    private int minValue,maxValue;
    private int pinNum,pinMode;

    private OnBarControlCallback callback;

    public BarControlDialog(Activity context){
        this.context = context;
        init(context);
    }


    void init(final Activity context){
        LayoutInflater layoutInflater = LayoutInflater.from(context);
        View contentView = layoutInflater.inflate(R.layout.dialog_bar_control, null);

        titleTextView = (TextView) contentView.findViewById(R.id.dialog_bar_control_title);
        modeTextView = (TextView) contentView.findViewById(R.id.dialog_bar_control_pin_mode);
        valueTextView = (TextView) contentView.findViewById(R.id.dialog_bar_control_value);
        minValueTextView = (TextView) contentView.findViewById(R.id.dialog_bar_control_min_value);
        maxValueTextView = (TextView) contentView.findViewById(R.id.dialog_bar_control_max_value);

        minusView = contentView.findViewById(R.id.dialog_bar_control_minus);
        minusView.setOnClickListener(this);
        plusView = contentView.findViewById(R.id.dialog_bar_control_plus);
        plusView.setOnClickListener(this);

        valueSeekBar = (SeekBar) contentView.findViewById(R.id.dialog_bar_control_bar);
        valueSeekBar.setOnSeekBarChangeListener(this);

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

    public void show(String title,int pinMode,int pinNum,int value,int minValue,int maxValue){
        if (dialog != null && !dialog.isShowing() && context!= null){
            titleTextView.setText("Pin "+title);
            modeTextView.setText(Common.getControlModeString(pinMode));
            valueSeekBar.setMax(maxValue);
            minValueTextView.setText(minValue+"");
            maxValueTextView.setText(maxValue+"");

            this.pinNum = pinNum;
            this.pinMode = pinMode;
            this.minValue = minValue;
            this.maxValue = maxValue;
            this.value = value;

            valueTextView.setText(value+"");
            valueSeekBar.setProgress(value);

            dialog.show();
        }
    }

    private void updateValue(int value){
        if (value < minValue || value > maxValue)
            return;
        this.value = value;
        valueTextView.setText(value+"");
        valueSeekBar.setProgress(value);
        if (callback != null)
            callback.onBarControlCallback(pinNum,pinMode,value);
    }

    public void setCallback(OnBarControlCallback callback) {
        this.callback = callback;
    }

    public void dismiss(){
        if (dialog != null && dialog.isShowing()){
            dialog.dismiss();
        }
    }

    @Override
    public void onClick(View v) {
        int i = v.getId();
        if (i == R.id.dialog_bar_control_minus) {
            updateValue(value - 1);
        }
        if (i == R.id.dialog_bar_control_plus) {
            updateValue(value + 1);
        }
    }

    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {

    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {

    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {
        updateValue(seekBar.getProgress());
    }
}
