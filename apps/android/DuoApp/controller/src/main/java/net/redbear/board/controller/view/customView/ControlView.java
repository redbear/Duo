package net.redbear.board.controller.view.customView;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import net.redbear.board.controller.R;
import net.redbear.board.controller.model.pin.Pin;
import net.redbear.board.controller.model.product.Board;
import net.redbear.board.controller.model.product.Common;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by dong on 3/16/16.
 */
public class ControlView extends RelativeLayout{

    private static final float ITEM_WIDTH_RATIO = 2.5f;
    private Context context;
    private float width;
    private float height;
    private ArrayList<PinView> pinViews;
    private ImageView icon;



    private float item_width;
    private float item_height;

    private PinViewCallback callback;

    public ControlView(Context context) {
        super(context);
        init(context);
    }

    public ControlView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public ControlView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context){
        this.context = context;
        setWillNotDraw(false);
        pinViews = new ArrayList<>();

        post(new Runnable() {
            @Override
            public void run() {
                width = getMeasuredWidth();
                height = getMeasuredHeight();
            }
        });
    }

    public void attachBoard(Board board){
        int n = board.getPinAmount()/2;
        item_height = height/n;
        item_width = ITEM_WIDTH_RATIO*item_height;

        LinearLayout linearLayoutLeft = new LinearLayout(context);
        linearLayoutLeft.setOrientation(LinearLayout.VERTICAL);
        LayoutParams linearLayoutLeftP = new LayoutParams((int)item_width,ViewGroup.LayoutParams.MATCH_PARENT);
        linearLayoutLeftP.addRule(ALIGN_PARENT_START);
        linearLayoutLeft.setLayoutParams(linearLayoutLeftP);
        this.addView(linearLayoutLeft);

        LinearLayout linearLayoutRight = new LinearLayout(context);
        linearLayoutRight.setOrientation(LinearLayout.VERTICAL);
        LayoutParams linearLayoutRightP = new LayoutParams((int)item_width
                                                                        ,ViewGroup.LayoutParams.MATCH_PARENT);
        linearLayoutRightP.addRule(ALIGN_PARENT_END);
        linearLayoutRight.setLayoutParams(linearLayoutRightP);

        this.addView(linearLayoutRight);

        for (int i =0 ;i < n;i++){
            PinView pinView = new PinView(context,i);
            Pin p = board.getPin(i);
            pinView.notifyState(p.getPinMode());
            pinView.setPinName(p.getPinName());
            pinView.setPinNum(p.getPinNum());
            pinView.setCallback(callback);
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,(int)item_height);
            pinView.setLayoutParams(layoutParams);
            linearLayoutLeft.addView(pinView,i);
            pinViews.add(pinView);
        }
        for (int j =0 ;j < n;j++){
            PinView pinView = new PinView(context,false,j+n);
            Pin p = board.getPin(j+n);
            pinView.notifyState(p.getPinMode());
            pinView.setPinName(p.getPinName());
            pinView.setPinNum(p.getPinNum());
            pinView.setCallback(callback);
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,(int)item_height);
            pinView.setLayoutParams(layoutParams);
            linearLayoutRight.addView(pinView,j);
            pinViews.add(pinView);
        }


        icon = new ImageView(context);
        icon.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_launcher));
        LayoutParams imageViewP = new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        imageViewP.addRule(CENTER_HORIZONTAL);
        imageViewP.setMargins(0,20,0,0);
        icon.setLayoutParams(imageViewP);

        icon.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_launcher));
        addView(icon);

        TextView resetAll = new TextView(context);
        resetAll.setText("Reset All");
        resetAll.setBackground(context.getResources().getDrawable(R.drawable.stroke_rect_red_solid_red));
        resetAll.setTextColor(Color.WHITE);
        resetAll.setPadding(30,20,30,20);
        resetAll.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });
        LayoutParams resetAllP = new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        resetAllP.addRule(CENTER_HORIZONTAL);
        resetAllP.addRule(ALIGN_PARENT_BOTTOM);
        resetAllP.setMargins(0,0,0,50);
        resetAll.setLayoutParams(resetAllP);
        resetAll.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (callback != null)
                    callback.onResetAllClick();
            }
        });
        addView(resetAll);


    }

    public void notifyPinData(int pinViewNum, final int pinMode, final int value){
        final PinView p = pinViews.get(pinViewNum);
        p.post(new Runnable() {
            @Override
            public void run() {
                p.notifyState(pinMode);
                p.setValue(value);
            }
        });
    }

    public void resetAll(){
        for (final PinView view : pinViews){
            if (view.getPinMode() != Common.PIN_MODE_DISABLE && view.getPinMode() != Common.PIN_MODE_IDE){
                view.post(new Runnable() {
                    @Override
                    public void run() {
                        view.notifyState(Common.PIN_MODE_IDE);
                        view.setValue(0);
                    }
                });
            }
        }
    }



    public void setCallback(PinViewCallback callback) {
        this.callback = callback;
    }


    public void setIcon(boolean isBLE){
        if (isBLE){
            icon.setImageBitmap(readBitMap(context,R.drawable.ble_icon));

        }else {
            icon.setImageBitmap(readBitMap(context,R.drawable.wifi_icon));
        }
    }


    private Bitmap readBitMap(Context context, int resId){
        BitmapFactory.Options opt = new BitmapFactory.Options();
        opt.inPreferredConfig = Bitmap.Config.RGB_565;
        opt.inPurgeable = true;
        opt.inSampleSize = 3;
        opt.inInputShareable = true;
        InputStream is = context.getResources().openRawResource(resId);
        return BitmapFactory.decodeStream(is,null,opt);
    }

}
