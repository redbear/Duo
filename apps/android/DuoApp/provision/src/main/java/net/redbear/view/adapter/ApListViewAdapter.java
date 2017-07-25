package net.redbear.view.adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import net.redbear.bleprovision.R;

import java.util.ArrayList;
import java.util.List;

import net.redbear.module.communicate.AP;

/**
 * Created by Dong on 16/1/6.
 */
public class ApListViewAdapter extends BaseAdapter {

    Context context;
    ArrayList<AP> aps;

    public ApListViewAdapter(Context context){
        this.context =context;
        aps = new ArrayList<>();
    }

    public void refreshData(List<AP> aps){
        this.aps.clear();
        for (AP ap : aps){
            this.aps.add(ap);
        }
        notifyDataSetChanged();
    }

    public void refreshData(AP ap){
        aps.add(ap);
        notifyDataSetChanged();
    }


    @Override
    public int getCount() {
        return aps.size();
    }

    @Override
    public Object getItem(int position) {
        return aps.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null){
            convertView = LayoutInflater.from(context).inflate(R.layout.adapter_ap_list,null);
        }

        if (position%2 == 0){
            convertView.setBackgroundColor(Color.argb(0, 0, 0, 0));
        }else {
            convertView.setBackgroundColor(Color.argb(0x20,0xfd,0x59,0x59));
        }


        AP ap = aps.get(position);
        ((TextView)convertView.findViewById(R.id.adapter_ap_list_name)).setText(ap.getSsid());
        ImageView rssi = (ImageView)convertView.findViewById(R.id.adapter_ap_list_sec_imageView);
        if (ap.getSecurity() == AP.WICED_SECURITY_OPEN){
            if (ap.getRssi() > AP.RSSI_VS){
                rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.open_signal_vs));
            }else if (ap.getRssi() > AP.RSSI_S){
                rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.open_signal_s));
            }else if (ap.getRssi() > AP.RSSI_n){
                rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.open_signal_n));
            }else if (ap.getRssi() > AP.RSSI_w){
                rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.open_signal_w));
            }else if (ap.getRssi() > AP.RSSI_vw){
                rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.open_signal_vw));
            }
        }else {
            if (ap.getRssi() > AP.RSSI_VS){
                rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.lock_signal_vs));
            }else if (ap.getRssi() > AP.RSSI_S){
                rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.lock_signal_s));
            }else if (ap.getRssi() > AP.RSSI_n){
                rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.lock_signal_n));
            }else if (ap.getRssi() > AP.RSSI_w){
                rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.lock_signal_w));
            }else if (ap.getRssi() > AP.RSSI_vw){
                rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.lock_signal_vw));
            }
        }
        return convertView;
    }
}
