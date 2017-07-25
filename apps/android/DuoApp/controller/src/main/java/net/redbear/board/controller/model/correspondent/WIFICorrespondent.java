package net.redbear.board.controller.model.correspondent;

import android.app.AlertDialog;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.google.gson.Gson;

import net.redbear.board.controller.model.product.Common;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.util.Arrays;

/**
 * Created by dong on 3/22/16.
 */
public class WIFICorrespondent implements Correspondent {

    private Socket socket;
    private String ip;
    private int port;

    private OutputStream outputStream;
    private InputStream inputStream;

    private static final int CONNECT_TIMEOUT = 5000;
    private Thread connectThread;
    private Thread receiveDataThread;
    private boolean CONNECTING;

    private Gson gson;
    private CorrespondentDataCallback callback;



    public WIFICorrespondent(String ip,int port){
        this.ip = ip;
        this.port = port;
        gson = new Gson();
    }



    @Override
    public void connect() {
        if (CONNECTING)
            return;
        CONNECTING = true;
        connectThread = new Thread(connectRunnable);
        connectThread.start();
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                if (CONNECTING){
                    disconnect();
                    if (callback != null)
                        callback.onDisconnect();
                }
            }
        },CONNECT_TIMEOUT);
    }

    @Override
    public void disconnect() {
        if (connectThread != null && connectThread.isAlive()){
            connectThread.interrupt();
        }
        if (receiveDataThread != null && receiveDataThread.isAlive()){
            receiveDataThread.interrupt();
        }
        try {
            if (outputStream != null)
                outputStream.close();
            if (inputStream != null)
                inputStream.close();
            if (socket != null)
                socket.close();
        }catch (Exception e){

        }
    }

    @Override
    public void setPinMode(int pin, int pinMode) {
        sendData(new DataPackage.Builder().setCommand("S").setPin(pin).setPinMode(pinMode).build());
    }

    @Override
    public void getPinValue(int pin) {
        sendData(new DataPackage.Builder().setCommand("G").setPin(pin).build());
    }

    @Override
    public void setPinData(int pin, int pinMode, int data) {
        DataPackage.Builder b = new DataPackage.Builder().setPin(pin).setPinMode(pinMode).setData(data);
        switch (pinMode){
            case Common.DUO_PIN_MODE_DIGITAL_WRITE:
                b.setCommand("T");
                break;
            case Common.DUO_PIN_MODE_PWM:
                b.setCommand("N");
                break;
            case Common.DUO_PIN_MODE_SERVO:
                b.setCommand("O");
                break;

        }
        sendData(b.build());
    }

    @Override
    public void resetAll() {
        sendData(new DataPackage.Builder().setCommand("R").build());
    }

    @Override
    public void setCorrespondentDataCallback(CorrespondentDataCallback callback) {
        this.callback = callback;
    }


    private void sendData(DataPackage d){
        String data = gson.toJson(d);
        Log.e("wifi","sendData :"+data);

        try {
            outputStream.write(data.getBytes());
            outputStream.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private Runnable connectRunnable = new Runnable() {
        @Override
        public void run() {
            try {
                socket = new Socket(ip,port);
                CONNECTING = false;
                if (callback != null)
                    callback.onConnectSuccess(false);
                outputStream = socket.getOutputStream();
                inputStream = socket.getInputStream();
                receiveData();
            } catch (IOException e) {
                e.printStackTrace();
                return;
            }
        }
    };

    private void receiveData(){
        receiveDataThread = new Thread(receiveDataRunnable);
        receiveDataThread.setUncaughtExceptionHandler(new Thread.UncaughtExceptionHandler() {
            @Override
            public void uncaughtException(Thread thread, Throwable ex) {

            }
        });
        receiveDataThread.start();
    }

    private Runnable receiveDataRunnable = new Runnable() {
        @Override
        public void run() {
            try {
                byte[] buffer = new byte[1000];
                int temp = -1;
                while((temp = inputStream.read(buffer)) != -1){

                    byte[] data = new byte[temp];
                    for(int i = 0; i < data.length;i++) {
                        data[i] = buffer[i];
                    }
                    Log.e("onDataReceive",Arrays.toString(data));
                    String receiveData = new String(data).trim();
                    Log.e("onDataReceive",receiveData);
                    if (callback != null && receiveData != null){
                        try {
                            callback.onDataReceive(gson.fromJson(receiveData,DataPackage.class));
                        }catch (Exception e){}
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
                return;
            }
        }
    };
}
