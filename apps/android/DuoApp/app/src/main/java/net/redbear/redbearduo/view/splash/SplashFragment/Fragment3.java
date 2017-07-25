package net.redbear.redbearduo.view.splash.SplashFragment;


import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import net.redbear.redbearduo.view.Activity.DevicesScan;
import net.redbear.redbearduo.view.Activity.MApplication;
import net.redbear.redbearduo.R;
import net.redbear.redbearduo.view.Activity.Splash_zero;

public class Fragment3 extends MyFragment {

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		super.onCreateView(inflater, container, savedInstanceState);

		View view = inflater.inflate(R.layout.splash_f3, container, false);
		Button button = (Button) view.findViewById(R.id.splash_btn);
		button.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				getActivity().startActivity(new Intent(getActivity(), Splash_zero.class));
				setSharePreferencesData(MApplication.appname, MApplication.sharePreferences_app_first_run, true);
			}
		});
		return view;
	}


	public void setSharePreferencesData(String filename,String arg, boolean data) {
		SharedPreferences.Editor editor = MApplication.getMApplication().getSharedPreferences(filename, Context.MODE_PRIVATE).edit();
		editor.putBoolean(arg,data);
		editor.commit();
	}


    @Override
    public void animation() {
        if (action)
            return;
        action =true;
    }
}
