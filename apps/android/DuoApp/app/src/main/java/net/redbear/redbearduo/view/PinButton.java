package net.redbear.redbearduo.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.Button;

/**
 * Created by Dong on 15/12/23.
 */
public class PinButton extends Button {

    private int attachPin;
    OnPinButtonClick onPinButtonClick;

    public PinButton(Context context) {
        super(context);
    }

    public PinButton(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public PinButton(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public PinButton(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
    }


    public void attach(int pin, final OnPinButtonClick onPinButtonClick){
        attachPin = pin;
        this.onPinButtonClick = onPinButtonClick;
        this.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onPinButtonClick != null){
                    onPinButtonClick.onClick(attachPin);
                }
            }
        });
    }


    public interface OnPinButtonClick{
        void onClick(int pin);
    }


}
