package net.redbear.view.adapter;

import android.content.Context;
import android.graphics.Color;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import net.redbear.bleprovision.R;
import net.redbear.module.communicate.AP;

import java.util.ArrayList;
import java.util.List;

public class DevicesListRecyclerViewAdapter extends RecyclerView.Adapter<DevicesListRecyclerViewAdapter.DeviceViewHolder> {

    private Context context;
    private ArrayList<AP> aps;
    private OnItemClickListener onItemClickListener;


    public DevicesListRecyclerViewAdapter(Context context){
        this.context =context;
        aps = new ArrayList<>();
    }

    @Override
    public DeviceViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View inflatedView = LayoutInflater.from(context).inflate(R.layout.adapter_ap_list, viewGroup, false);
        return new DeviceViewHolder(inflatedView);
    }

    @Override
    public void onBindViewHolder(DeviceViewHolder viewHolder, final int i) {

        if (onItemClickListener != null)
        {
            viewHolder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    onItemClickListener.onItemClick(v,i);
                }
            });
        }

        if (i%2 == 0){
            viewHolder.parent.setBackgroundColor(Color.argb(0, 0, 0, 0));
        }else {
            viewHolder.parent.setBackgroundColor(Color.argb(0x20, 0xfd, 0x59, 0x59));
        }


        AP ap = aps.get(i);
        viewHolder.ssid.setText(ap.getSsid());
        if (ap.getSecurity() == AP.WICED_SECURITY_OPEN){
            if (ap.getRssi() > AP.RSSI_VS){
                viewHolder.rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.open_signal_vs));
            }else if (ap.getRssi() > AP.RSSI_S){
                viewHolder.rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.open_signal_s));
            }else if (ap.getRssi() > AP.RSSI_n){
                viewHolder.rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.open_signal_n));
            }else if (ap.getRssi() > AP.RSSI_w){
                viewHolder.rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.open_signal_w));
            }else if (ap.getRssi() > AP.RSSI_vw){
                viewHolder.rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.open_signal_vw));
            }
        }else {
            if (ap.getRssi() > AP.RSSI_VS){
                viewHolder.rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.lock_signal_vs));
            }else if (ap.getRssi() > AP.RSSI_S){
                viewHolder.rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.lock_signal_s));
            }else if (ap.getRssi() > AP.RSSI_n){
                viewHolder.rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.lock_signal_n));
            }else if (ap.getRssi() > AP.RSSI_w){
                viewHolder.rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.lock_signal_w));
            }else if (ap.getRssi() > AP.RSSI_vw){
                viewHolder.rssi.setImageDrawable(context.getResources().getDrawable(R.drawable.lock_signal_vw));
            }
        }



    }

    @Override
    public int getItemCount() {
        return aps.size();
    }

    public AP getItem(int position) {
        if (aps.size() < position || aps.size() == 0)
            return null;
        return aps.get(position);
    }

    public class DeviceViewHolder extends RecyclerView.ViewHolder {
        View parent;
        ImageView rssi;
        TextView ssid;

        public DeviceViewHolder(View itemView) {
            super(itemView);
            parent = itemView;
            rssi = (ImageView) itemView.findViewById(R.id.adapter_ap_list_sec_imageView);
            ssid = (TextView) itemView.findViewById(R.id.adapter_ap_list_name);
        }
    }


    public void refreshData(List<AP> aps){
        if (aps == null)
            return;
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


    public void clean(){
        aps.clear();
        notifyDataSetChanged();
    }


    public interface OnItemClickListener
    {
        void onItemClick(View view, int position);
    }

    public void setOnItemClickListener(OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }
}
