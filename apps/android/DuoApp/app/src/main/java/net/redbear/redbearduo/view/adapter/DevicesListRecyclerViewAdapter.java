package net.redbear.redbearduo.view.adapter;

import android.content.Context;
import android.graphics.Color;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import net.redbear.redbearduo.R;

import java.util.ArrayList;

import net.redbear.redbearduo.data.Common;
import net.redbear.redbearduo.data.device.Device;

public class DevicesListRecyclerViewAdapter extends RecyclerView.Adapter<DevicesListRecyclerViewAdapter.DeviceViewHolder> {

    private Context mContext;
    private ArrayList<Device> devices;
    private int connectState;
    private OnItemClickLitener onItemClickLitener;

    public DevicesListRecyclerViewAdapter(Context context,ArrayList<Device> devices,int connectState) {
        mContext = context;
        this.devices = devices;
        this.connectState = connectState;
    }



    @Override
    public DeviceViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View inflatedView = LayoutInflater.from(mContext).inflate(R.layout.adapter_device_list, viewGroup, false);
        return new DeviceViewHolder(inflatedView);
    }

    @Override
    public void onBindViewHolder(DeviceViewHolder viewHolder, final int i) {
        Device d = getItem(i);

        if (onItemClickLitener != null)
        {
            viewHolder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    onItemClickLitener.onItemClick(v,i);
                }
            });
        }

        if (i%2 == 0){
            viewHolder.parent.setBackgroundColor(Color.argb(0,0,0,0));
        }else {
            viewHolder.parent.setBackgroundColor(Color.rgb(0xf7,0xe2,0xe2));
        }


        if (d.name == null){
            viewHolder.deviceNameTextView.setText("UKnown");
        }else {
            viewHolder.deviceNameTextView.setText(d.name);
        }
        viewHolder.deviceIDTextView.setText(d.macAddress);

        switch (d.getConnectState()){
            case Common.CONNECT_STATE_DEFAULT:
                viewHolder.deviceStateImageView.setImageDrawable(mContext.getResources().getDrawable(R.drawable.ds_na));
                viewHolder.deviceStateTextView.setText("NA");
                viewHolder.deviceImage.setImageDrawable(mContext.getResources().getDrawable(R.drawable.duo_notactive));
                break;
            case Common.CONNECT_STATE_PROVISION:
                viewHolder.deviceStateImageView.setImageDrawable(mContext.getResources().getDrawable(R.drawable.ds_setup));
                viewHolder.deviceStateTextView.setText("Setup");
                viewHolder.deviceImage.setImageDrawable(mContext.getResources().getDrawable(R.drawable.duo_active));
                break;
            case Common.CONNECT_STATE_CONTROLLER:
                viewHolder.deviceStateImageView.setImageDrawable(mContext.getResources().getDrawable(R.drawable.ds_connect));
                viewHolder.deviceStateTextView.setText("Connect");
                viewHolder.deviceImage.setImageDrawable(mContext.getResources().getDrawable(R.drawable.duo_active));
                break;
        }

    }

    public void setDevices(ArrayList<Device> ds){
        devices.clear();
        for (Device d : ds){
            devices.add(d);
        }
        notifyDataSetChanged();
    }
    public Device getItem(int position) {
        return devices.get(position);
    }

    @Override
    public int getItemCount() {
        return devices.size();
    }



    public class DeviceViewHolder extends RecyclerView.ViewHolder {
        View parent;
        ImageView deviceImage;
        TextView deviceNameTextView,deviceIDTextView;
        ImageView deviceStateImageView;
        TextView deviceStateTextView;

        public DeviceViewHolder(View itemView) {
            super(itemView);
            parent = itemView;
            deviceImage = (ImageView) itemView.findViewById(R.id.adapter_device_list_device_imageView);
            deviceNameTextView = (TextView) itemView.findViewById(R.id.adapter_device_list_device_nameTextView);
            deviceIDTextView = (TextView) itemView.findViewById(R.id.adapter_device_list_device_idTextView);
            deviceStateImageView = (ImageView) itemView.findViewById(R.id.adapter_device_list_device_stateImageView);
            deviceStateTextView = (TextView) itemView.findViewById(R.id.adapter_device_list_device_stateTextView);
        }
    }


    public interface OnItemClickLitener
    {
        void onItemClick(View view, int position);
    }

    public void setOnItemClickLitener(OnItemClickLitener onItemClickLitener) {
        this.onItemClickLitener = onItemClickLitener;
    }
}
