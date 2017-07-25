package net.redbear.redbearduo.view.splash.SplashFragment;


import android.animation.ObjectAnimator;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AccelerateInterpolator;
import android.widget.ImageView;

import net.redbear.redbearduo.R;

public class Fragment1 extends MyFragment {
	View view;
	ImageView cloudImage,bleImage,wifiImage;
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		super.onCreateView(inflater, container, savedInstanceState);
		view = inflater.inflate(R.layout.splash_f1, container, false);

		cloudImage = (ImageView) view.findViewById(R.id.splash1_cloud_image);

		bleImage = (ImageView) view.findViewById(R.id.splash1_ble_image);

		wifiImage = (ImageView) view.findViewById(R.id.splash1_wifi_image);


		return view;
	}

	@Override
	public void onResume() {
		super.onResume();
	}

    @Override
    public void animation() {
        if (action)
            return;
        action =true;
        cloudImage.post(new Runnable() {
            @Override
            public void run() {
                DisplayMetrics dm = new DisplayMetrics();
                getActivity().getWindowManager().getDefaultDisplay().getMetrics(dm);
                int width = dm.widthPixels;
                Log.e("pixels","width :"+width+"height :"+dm.heightPixels);
                int w = (int)cloudImage.getX();
                ObjectAnimator animator = ObjectAnimator.ofFloat(cloudImage, "X", 0 - w, w);
                animator.setDuration(1000);
                animator.setInterpolator(new AccelerateInterpolator());
                animator.start();
            }
        });

        bleImage.post(new Runnable() {
            @Override
            public void run() {
                DisplayMetrics dm = new DisplayMetrics();
                getActivity().getWindowManager().getDefaultDisplay().getMetrics(dm);
                int width = dm.widthPixels;
                int w = (int)bleImage.getX();
                ObjectAnimator animator = ObjectAnimator.ofFloat(bleImage, "X", width, w);
                animator.setDuration(1000);
                animator.setInterpolator(new AccelerateInterpolator());
                animator.start();
            }
        });

        wifiImage.post(new Runnable() {
            @Override
            public void run() {
                DisplayMetrics dm = new DisplayMetrics();
                getActivity().getWindowManager().getDefaultDisplay().getMetrics(dm);
                int height = dm.heightPixels;
                int h = (int)wifiImage.getY();
                ObjectAnimator animator = ObjectAnimator.ofFloat(wifiImage, "Y", height, h);
                animator.setDuration(1000);
                animator.setInterpolator(new AccelerateInterpolator());
                animator.start();
            }
        });
    }
}
