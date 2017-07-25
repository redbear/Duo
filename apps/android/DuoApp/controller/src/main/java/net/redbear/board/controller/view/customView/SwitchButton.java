package net.redbear.board.controller.view.customView;

import android.content.Context;
import android.graphics.BlurMaskFilter;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.ViewConfiguration;
import android.view.ViewParent;
import android.widget.CheckBox;

/**
 * Created by dong on 3/17/16.
 */
public class SwitchButton extends CheckBox {

    private Paint backgroundPaint;
    private Paint buttonPaint;
    private Paint checkPaint;
    private Paint unCheckPaint;
    private Paint buttonMaskFilterPaint;

    private static final int STRIKE_COLOR = Color.rgb(0xd0,0x50,0x50);
    private static final int CHECK_COLOR = Color.rgb(0xd0,0x50,0x50);
    private static final int UNCHECK_COLOR = Color.WHITE;
    private static final int BUTTON_CLICK_COLOR = Color.rgb(200,200,200);
    private static final int BUTTON_UNCLICK_COLOR = Color.WHITE;
    private static final int BUTTON_MASK_FILTER_COLOR = Color.argb(0x88,0,0,0);
    private int button_Color;

    private float height;
    private float width;
    private static float VIEW_PADDING = 5;
    private static float BUTTON_PADDING_LEFT = 2;
   // private static final float BUTTON_R_RATIO = 0.27f;
    private static final float BUTTON_R_RATIO = 0.25f;
    private float buttonR;
    private float buttonX;

    private boolean checked = false;

    private float mFirstDownY;

    private float mFirstDownX;

    private ViewParent mParent;

    private float mBtnInitPos;

    private float mBtnOnPos;

    private float mBtnOffPos;

    private int mTouchSlop;
    private int mClickTimeout;
    private boolean mTurningOn;

    private boolean clickable;


    private int _width;


    public SwitchButton(Context context) {
        super(context);
        init(context);
    }
    public SwitchButton(Context context, int width) {
        super(context);
        _width = width;
        init(context);
    }

    public SwitchButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public SwitchButton(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }



    private void init(Context context){

        backgroundPaint = new Paint(Paint.ANTI_ALIAS_FLAG);

        backgroundPaint.setStyle(Paint.Style.STROKE);
        backgroundPaint.setColor(STRIKE_COLOR);
        backgroundPaint.setStrokeWidth(5);

        buttonPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        buttonPaint.setStyle(Paint.Style.FILL);

        buttonMaskFilterPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        buttonMaskFilterPaint.setStyle(Paint.Style.FILL);
        buttonMaskFilterPaint.setColor(BUTTON_MASK_FILTER_COLOR);
        BlurMaskFilter bmf = new BlurMaskFilter(7, BlurMaskFilter.Blur.SOLID);
        buttonMaskFilterPaint.setMaskFilter(bmf);

        checkPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        checkPaint.setStyle(Paint.Style.FILL);
        checkPaint.setColor(CHECK_COLOR);

        unCheckPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        unCheckPaint.setStyle(Paint.Style.FILL);
        unCheckPaint.setColor(UNCHECK_COLOR);

        mTouchSlop = ViewConfiguration.get(context).getScaledTouchSlop();
        mClickTimeout = ViewConfiguration.getPressedStateDuration()
                + ViewConfiguration.getTapTimeout();
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        width = _width - VIEW_PADDING*2;

        buttonR = (BUTTON_R_RATIO-0.005f)* width;
        height = BUTTON_R_RATIO* width*2;
        mBtnOnPos = width - buttonR - BUTTON_PADDING_LEFT + VIEW_PADDING;
        mBtnOffPos = BUTTON_PADDING_LEFT + buttonR + VIEW_PADDING;
        if (checked){
            buttonX = mBtnOnPos;
        }else {
            buttonX = mBtnOffPos;
        }
        button_Color = BUTTON_UNCLICK_COLOR;

        int w = resolveSize(_width, widthMeasureSpec);
        int h = resolveSize((int)(_width*0.3*2), heightMeasureSpec);
        setMeasuredDimension(w, h);


    }

    @Override
    protected void onDraw(Canvas canvas) {
        setLayerType(LAYER_TYPE_SOFTWARE, null);

        Path p = new Path();
        p.moveTo(height/2+VIEW_PADDING,height+VIEW_PADDING);
        p.arcTo(new RectF(VIEW_PADDING,0+VIEW_PADDING,height+VIEW_PADDING,height+VIEW_PADDING),90,180);
        p.lineTo(width - height+VIEW_PADDING,0+VIEW_PADDING);
        p.arcTo(new RectF(width - height+VIEW_PADDING,0+VIEW_PADDING,width+VIEW_PADDING,height+VIEW_PADDING),270,180);
        p.close();

        canvas.drawPath(p,backgroundPaint);

        Path llP = new Path();

        llP.moveTo(buttonX,height+VIEW_PADDING);
        llP.lineTo(height/2+VIEW_PADDING, height + VIEW_PADDING);
        llP.arcTo(new RectF(VIEW_PADDING,0+VIEW_PADDING,height+VIEW_PADDING,height+VIEW_PADDING),90,180);
        llP.lineTo(buttonX,0+VIEW_PADDING);
        llP.close();
        canvas.drawPath(llP,checkPaint);

        canvas.drawCircle(buttonX,height/2 + VIEW_PADDING,buttonR,buttonMaskFilterPaint);

        buttonPaint.setColor(button_Color);
        canvas.drawCircle(buttonX,height/2 + VIEW_PADDING,buttonR,buttonPaint);
    }


    public void toggle() {
        setCheck(!checked);
        postInvalidate();
    }

    public void setValue(boolean value){
        if (value == checked)
            return;
        else {
            toggle();
        }
    }




    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (!clickable)
            return false;
        int action = event.getAction();
        float x = event.getX();
        float y = event.getY();
        float deltaX = Math.abs(x - mFirstDownX);
        float deltaY = Math.abs(y - mFirstDownY);
        switch (action) {
            case MotionEvent.ACTION_DOWN:
                attemptClaimDrag();
                mFirstDownX = x;
                mFirstDownY = y;
                button_Color = BUTTON_CLICK_COLOR;
                mBtnInitPos = checked ? mBtnOnPos : mBtnOffPos;
                break;
            case MotionEvent.ACTION_MOVE:
                buttonX = mBtnInitPos + x - mFirstDownX;
                if (buttonX >= mBtnOnPos) {
                    buttonX = mBtnOnPos;
                }
                if (buttonX <= mBtnOffPos) {
                    buttonX = mBtnOffPos;
                }
                mTurningOn = buttonX > (mBtnOffPos - mBtnOnPos) / 2 + mBtnOnPos;

                break;
            case MotionEvent.ACTION_UP:
                button_Color = BUTTON_UNCLICK_COLOR;
                float time = event.getEventTime() - event.getDownTime();
                if (deltaY < mTouchSlop && deltaX < mTouchSlop && time < mClickTimeout) {
                    toggle();
                }else {
                    setCheck(mTurningOn);
                    checked = mTurningOn;
                }

                break;
        }

        invalidate();
        return isEnabled();
    }

    private void setCheck(boolean check){
        checked = check;
        buttonX = check?mBtnOnPos:mBtnOffPos;
    }

    public void setClickable(boolean clickable){
        this.clickable = clickable;
    }

    private void attemptClaimDrag() {
        mParent = getParent();
        if (mParent != null) {
            mParent.requestDisallowInterceptTouchEvent(true);
        }
    }
}
