package net.redbear.redbearduo.view.Activity;

import android.content.Intent;
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.os.Bundle;
import android.widget.RadioButton;
import android.widget.RadioGroup;

import net.redbear.redbearduo.R;
import net.redbear.redbearduo.view.splash.SplashFragment.MyFragment;
import net.redbear.redbearduo.view.splash.ViewPagerAdapter;

import static net.redbear.redbearduo.view.Activity.MApplication.getSharePreferencesData;

public class Splash extends FragmentActivity {

    private ViewPager viewPage;

    private ViewPagerAdapter mPgAdapter;
    private RadioGroup dotLayout;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);

//        final PathView pathView = (PathView) findViewById(R.id.pathView);
//        pathView.setFillAfter(true);
//        pathView.useNaturalColors();
//        pathView.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                pathView.getPathAnimator().
//                        //pathView.getSequentialPathAnimator().
//                        delay(100).
//                        duration(1500).
//                        interpolator(new AccelerateDecelerateInterpolator()).
//                        start();
//            }
//        });
//        final PathView pathView2 = (PathView) findViewById(R.id.pathView2);
//        pathView2.setFillAfter(true);
//        pathView2.useNaturalColors();
//        pathView2.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                pathView2.getPathAnimator().
//                        //pathView.getSequentialPathAnimator().
//                                delay(100).
//                        duration(1500).
//                        interpolator(new AccelerateDecelerateInterpolator()).
//                        start();
//            }
//        });


        MApplication.FIRST_RUN_STATE = getSharePreferencesData(MApplication.appname,MApplication.sharePreferences_app_first_run);
        if (!MApplication.FIRST_RUN_STATE) {
            initView();
            viewPage.setOnPageChangeListener(new MyPagerChangeListener());
        } else {
            Intent intent;
            intent = new Intent(Splash.this,Splash_zero.class);
            startActivity(intent);
            finish();
        }
    }

    private void initView() {
        dotLayout = (RadioGroup) findViewById(R.id.advertise_point_group);
        viewPage = (ViewPager) findViewById(R.id.splash_viewPager);

        mPgAdapter = new ViewPagerAdapter(getSupportFragmentManager());
        viewPage.setAdapter(mPgAdapter);

    }

    public class MyPagerChangeListener implements ViewPager.OnPageChangeListener {

        public void onPageSelected(int position) {

        }

        public void onPageScrollStateChanged(int arg0) {

        }

        public void onPageScrolled(int position, float positionOffset,
                                   int positionOffsetPixels) {
            ((RadioButton) dotLayout.getChildAt(position)).setChecked(true);
            ((MyFragment)mPgAdapter.getItem(position)).animation();
        }

    }


}
