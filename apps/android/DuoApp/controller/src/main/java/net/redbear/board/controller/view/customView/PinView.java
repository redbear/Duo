package net.redbear.board.controller.view.customView;

import android.content.Context;
import android.graphics.Color;
import android.text.TextPaint;
import android.util.AttributeSet;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import net.redbear.board.controller.R;
import net.redbear.board.controller.model.product.Common;
import net.redbear.board.controller.model.product.PinAble;
import static net.redbear.board.controller.model.product.Common.*;

/**
 * Created by dong on 3/21/16.
 */
public class PinView extends RelativeLayout implements View.OnClickListener,PinAble{

    private boolean isLeft = true;
    private Context context;
    private float height;

    private TextView pinButton;
    private RelativeLayout controlLayout;
    private TextView stateText;

    private TextView controlTextView;
    private SwitchButton controlSwitch;
    private TextView switchTextView;

    private int pinNum;
    private int pinViewNum;
    private int pinMode = Common.PIN_MODE_IDE;

    private PinViewCallback callback;

    public PinView(Context context, boolean isLeft,int pinViewNum) {
        super(context);
        this.isLeft = isLeft;
        this.pinViewNum = pinViewNum;
        init(context);
    }

    public PinView(Context context ,int pinViewNum) {
        super(context);
        this.pinViewNum = pinViewNum;
        init(context);
    }
    public PinView(Context context) {
        super(context);
        init(context);
    }

    public PinView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public PinView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }


    private void init(final Context context){
        this.context = context;
        setWillNotDraw(false);


        pinButton = new TextView(context);
        pinButton.setTag(1);
        stateText = new TextView(context);
        controlLayout = new RelativeLayout(context);
        controlSwitch = new SwitchButton(context,90);
        controlSwitch.setClickable(false);
        switchTextView = new TextView(context);
        controlTextView = new TextView(context);


        post(new Runnable() {
            @Override
            public void run() {
                height = getMeasuredHeight();
                //pin button
                pinButton.setGravity(Gravity.CENTER);
                pinButton.setId(R.id.pinViewButtonLeftView);
                pinButton.setTextSize(17);
                pinButton.setOnClickListener(PinView.this);
                LayoutParams layoutParams = new LayoutParams((int)(height*0.7),(int)(height*0.7));
                layoutParams.setMarginStart(10);
                if (isLeft){
                    layoutParams.addRule(ALIGN_PARENT_START);
                }else {
                    layoutParams.addRule(ALIGN_PARENT_END);
                }
                layoutParams.addRule(CENTER_HORIZONTAL);
                pinButton.setLayoutParams(layoutParams);
                addView(pinButton);

                LinearLayout linearLayout = new LinearLayout(context);
                linearLayout.setTag(2);
                linearLayout.setOnClickListener(PinView.this);

                linearLayout.setOrientation(LinearLayout.VERTICAL);
                LayoutParams layoutParams2 = new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.MATCH_PARENT);
                if (isLeft){
                    layoutParams2.addRule(END_OF, R.id.pinViewButtonLeftView);
                }else {
                    layoutParams2.addRule(START_OF,R.id.pinViewButtonLeftView);
                }
                linearLayout.setLayoutParams(layoutParams2);
                LayoutParams layoutParams3 = new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,(int)(height*0.5));
                controlLayout.setLayoutParams(layoutParams3);
                controlLayout.setGravity(Gravity.CENTER);
                linearLayout.addView(controlLayout,0);

                stateText.setGravity(Gravity.CENTER);
                stateText.setTextColor(context.getResources().getColor(R.color.colorPrimary));
                stateText.setLayoutParams(layoutParams3);
                linearLayout.addView(stateText,1);

                controlTextView.setText(getWidth()+"");
                LayoutParams layoutParams5 = new LayoutParams((int)(getWidth()*0.4f), ViewGroup.LayoutParams.MATCH_PARENT);
                controlTextView.setGravity(Gravity.CENTER);
                controlTextView.setTextColor(context.getResources().getColor(R.color.colorPrimary));
                controlTextView.setBackground(context.getResources().getDrawable(R.drawable.stroke_rect_red_solid_null));
                controlTextView.setLayoutParams(layoutParams5);

                controlSwitch.setId(R.id.controlViewSwitch);
                LayoutParams layoutParams4 = new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                layoutParams4.addRule(CENTER_VERTICAL);
                controlSwitch.setLayoutParams(layoutParams4);

                switchTextView.setText("HHH");
                switchTextView.setTextColor(context.getResources().getColor(R.color.colorPrimary));
                switchTextView.setGravity(Gravity.CENTER_VERTICAL);
                LayoutParams layoutParams1 = new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.MATCH_PARENT);
                layoutParams1.addRule(END_OF,R.id.controlViewSwitch);
                switchTextView.setLayoutParams(layoutParams1);

                controlLayout.addView(controlSwitch);
                controlLayout.addView(switchTextView);
                controlLayout.addView(controlTextView);

                addView(linearLayout);
            }
        });
    }

    public void notifyState(int pinMode){
        this.pinMode = pinMode;
        if(pinMode == PIN_MODE_DISABLE){
            pinButton.setAlpha(0.3f);
            pinButton.setEnabled(false);
        }else {
            pinButton.setAlpha(1f);
            pinButton.setEnabled(true);
        }

        if (pinMode != PIN_MODE_DISABLE &&  pinMode != PIN_MODE_IDE){
            pinButton.setBackground(context.getResources().getDrawable(R.drawable.stroke_round_red));
            pinButton.setTextColor(context.getResources().getColor(R.color.colorPrimary));
            controlLayout.setVisibility(VISIBLE);
            controlLayout.setEnabled(true);
        }else {
            clearControl();
            pinButton.setBackground(context.getResources().getDrawable(R.drawable.stroke_round_gray));
            pinButton.setTextColor(Color.GRAY);
        }

        switch (pinMode){
            case PIN_MODE_DIGITAL_READ:
                stateText.setText("Digital Read");
                notifyControlView(0);
                break;
            case PIN_MODE_DIGITAL_WRITE:
                stateText.setText("Digital Write");
                notifyControlView(1);
                break;
            case PIN_MODE_PWM:
                stateText.setText("PWM");
                notifyControlView(0);
                break;
            case PIN_MODE_ANALOG_READ:
                stateText.setText("Analog Read");
                notifyControlView(0);
                break;
            case PIN_MODE_SERVO:
                stateText.setText("Servo");
                notifyControlView(0);
                break;
        }
    }

    private void notifyControlView(int state){
        if (state == 0){
            switchTextView.setVisibility(GONE);
            controlSwitch.setVisibility(GONE);
            controlTextView.setVisibility(VISIBLE);
        }else {
            switchTextView.setVisibility(VISIBLE);
            controlSwitch.setVisibility(VISIBLE);
            controlTextView.setVisibility(GONE);
        }
    }

    private void clearControl(){
        controlLayout.setVisibility(GONE);
        stateText.setText("");
    }

    public int getPinMode() {
        return pinMode;
    }

    @Override
    public void onClick(View v) {
        if (callback == null)
            return;
        int i = (Integer) v.getTag();
        if (i == 1) {
            callback.onPinClick(pinNum,pinViewNum);
        }else if(i == 2) {
            callback.onControlClick(pinNum,pinViewNum,pinMode);
        }
    }


    @Override
    public void setPinName(String name) {
        pinButton.setText(name);
        if (name.length() > 2){
            pinButton.post(new Runnable() {
                @Override
                public void run() {
                    pinButton.setTextSize(10);
                }
            });
        }else{
            pinButton.post(new Runnable() {
                @Override
                public void run() {
                    pinButton.setTextSize(17);
                }
            });
        }
    }

    @Override
    public void setValue(int value) {
        controlTextView.setText(""+value);
        controlSwitch.setValue(value != 0 ?true:false);
        switchTextView.setText(value != 0 ?"HIGHT":"LOW");
    }

    @Override
    public void setPinNum(int pinNum) {
        this.pinNum = pinNum;
    }

    public void setCallback(PinViewCallback callback) {
        this.callback = callback;
    }
}
