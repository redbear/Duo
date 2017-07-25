package net.redbear.view;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;

import net.redbear.bleprovision.R;

import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by dong on 3/9/16.
 */
public class DuoStateView extends ImageView {

    private final static float LED_X = 0.496f;
    private final static float LED_Y = 0.716f;

    private final static int FLASH_MODE_BLINK = 0;
    private final static int FLASH_MODE_BREATHE = 1;


    private int r = 0;
    private int r_max;
    private Paint paint;
    private int color;
    private int mode;
    private int duration;

    private Timer timer;
    private boolean orientation = true;

    public DuoStateView(Context context) {
        super(context);
    }

    public DuoStateView(Context context, AttributeSet attrs) {
        super(context, attrs);
        setAttrs(context,attrs);
    }

    public DuoStateView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        setAttrs(context,attrs);
    }


    void setAttrs(Context context,AttributeSet attrs){
        TypedArray typedArray = context.obtainStyledAttributes(attrs, R.styleable.DuoStateView);
        color = typedArray.getColor(R.styleable.DuoStateView_Color,Color.BLUE);
        mode = typedArray.getColor(R.styleable.DuoStateView_FlashMode,FLASH_MODE_BLINK);
        duration = typedArray.getColor(R.styleable.DuoStateView_duration,270);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        r_max = (int)(getMeasuredWidth()*0.05);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        paint.setColor(color);
        canvas.drawCircle(getWidth()*LED_X,getHeight()*LED_Y,r/100.0f*r_max,paint);
        flash();
    }

    public void flash(){
        if (timer == null)
            timer = new Timer();
        else
            return;
        TimerTask timerTask = new TimerTask() {
            @Override
            public void run() {
                switch (mode){
                    case FLASH_MODE_BLINK:
                        blink();
                        break;
                    case FLASH_MODE_BREATHE:
                        breathe();
                        break;
                }
            }
        };
        timer.schedule(timerTask,0,duration);
    }

    void blink(){
        r = r > 0 ? 0:100;
        postInvalidate();
    }

    void breathe(){
        if (orientation){
            r += 1;
        }else {
            r -= 1;
        }
        if (orientation && r >= 100)
            orientation = false;
        else if (!orientation && r <= 0)
            orientation = true;
        postInvalidate();
    }

}
