package net.redbear.redbearduo.view.splash;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import net.redbear.redbearduo.view.splash.SplashFragment.Fragment1;
import net.redbear.redbearduo.view.splash.SplashFragment.Fragment2;
import net.redbear.redbearduo.view.splash.SplashFragment.Fragment3;

public class ViewPagerAdapter extends FragmentStatePagerAdapter {
    private Fragment f1,f2,f3;

	public ViewPagerAdapter(FragmentManager fm) {
		super(fm);
	}
	@Override
	public Fragment getItem(int arg0) {
		switch (arg0) {
			case 0:
                if (f1 == null)
                    f1 = new Fragment1();
				return f1;
			case 1:
                if (f2 == null)
                    f2 = new Fragment2();
				return f2;
			case 2:
                if (f3 == null)
                    f3 = new Fragment3();
				return f3;
		}
		return null;
	}
	@Override
	public int getCount() {
		return 3;
	}
}
