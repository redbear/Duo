package net.redbear.redbearduo.view.Activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import net.redbear.redbearduo.R;

/**
 * Created by dong on 16/3/30.
 */
public class InfoActivity extends Activity{

    public static Intent getInfoActivityIntent(Context context){
        return new Intent(context,InfoActivity.class);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_info);
    }
}
