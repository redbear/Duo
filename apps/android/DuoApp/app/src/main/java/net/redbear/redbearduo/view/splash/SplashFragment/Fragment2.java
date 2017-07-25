package net.redbear.redbearduo.view.splash.SplashFragment;


import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AccelerateInterpolator;
import android.widget.ImageView;

import net.redbear.redbearduo.R;

public class Fragment2 extends MyFragment {
	View view;
	View bgView;
	ImageView pImage,hImage,conImage,kImage,carImage,mImage;
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		super.onCreateView(inflater, container, savedInstanceState);
		view = inflater.inflate(R.layout.splash_f2, container, false);


        bgView = view.findViewById(R.id.splash2_bg);

        pImage = (ImageView) view.findViewById(R.id.splash2_printMachine_image);
        hImage = (ImageView) view.findViewById(R.id.splash2_heart_image);
        conImage = (ImageView) view.findViewById(R.id.splash2_controller_image);
        kImage = (ImageView) view.findViewById(R.id.splash2_keyboard_image);
        carImage = (ImageView) view.findViewById(R.id.splash2_car_image);
        mImage = (ImageView) view.findViewById(R.id.splash2_mouse_image);

		return view;
	}
    @Override
    public void animation() {
        if (action)
            return;
        action =true;

        new Handler().post(new Runnable() {
            @Override
            public void run() {
                AnimatorSet bouncer = new AnimatorSet();

                ObjectAnimator animator1 = ObjectAnimator.ofFloat(hImage, "alpha", 0, 1);
                animator1.setDuration(100);
                animator1.setInterpolator(new AccelerateInterpolator());
                ObjectAnimator animator11 = ObjectAnimator.ofFloat(hImage, "scaleX",0f, 1.0f);
                animator11.setDuration(100);
                animator11.setInterpolator(new AccelerateInterpolator());

                ObjectAnimator animator2 = ObjectAnimator.ofFloat(pImage, "alpha", 0, 1);
                animator2.setDuration(100);
                animator2.setInterpolator(new AccelerateInterpolator());
                ObjectAnimator animator22 = ObjectAnimator.ofFloat(pImage, "scaleX",0f, 1.0f);
                animator11.setDuration(100);
                animator11.setInterpolator(new AccelerateInterpolator());

                ObjectAnimator animator3 = ObjectAnimator.ofFloat(mImage, "alpha", 0, 1);
                animator3.setDuration(100);
                animator3.setInterpolator(new AccelerateInterpolator());
                ObjectAnimator animator33 = ObjectAnimator.ofFloat(mImage, "scaleX",0f, 1.0f);
                animator11.setDuration(100);
                animator11.setInterpolator(new AccelerateInterpolator());

                ObjectAnimator animator4 = ObjectAnimator.ofFloat(carImage, "alpha", 0, 1);
                animator4.setDuration(100);
                animator4.setInterpolator(new AccelerateInterpolator());
                ObjectAnimator animator44 = ObjectAnimator.ofFloat(carImage, "scaleX",0f, 1.0f);
                animator11.setDuration(100);
                animator11.setInterpolator(new AccelerateInterpolator());

                ObjectAnimator animator5 = ObjectAnimator.ofFloat(conImage, "alpha", 0, 1);
                animator5.setDuration(100);
                animator5.setInterpolator(new AccelerateInterpolator());
                ObjectAnimator animator55 = ObjectAnimator.ofFloat(conImage, "scaleX",0f, 1.0f);
                animator11.setDuration(100);
                animator11.setInterpolator(new AccelerateInterpolator());

                ObjectAnimator animator6 = ObjectAnimator.ofFloat(kImage, "alpha", 0, 1);
                animator6.setDuration(100);
                animator6.setInterpolator(new AccelerateInterpolator());
                ObjectAnimator animator66 = ObjectAnimator.ofFloat(kImage, "scaleX",0f, 1.0f);
                animator11.setDuration(100);
                animator11.setInterpolator(new AccelerateInterpolator());

                bouncer.play(animator1).with(animator11).before(animator2);
                bouncer.play(animator2).with(animator22).before(animator3);
                bouncer.play(animator3).with(animator33).before(animator4);
                bouncer.play(animator4).with(animator44).before(animator5);
                bouncer.play(animator5).with(animator55).before(animator6).with(animator66);
                bouncer.start();
            }
        });
    }
}
