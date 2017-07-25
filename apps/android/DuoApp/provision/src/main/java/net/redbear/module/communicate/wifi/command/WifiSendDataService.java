package net.redbear.module.communicate.wifi.command;

import android.os.Environment;
import android.util.Log;

import com.google.gson.Gson;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.Socket;
import java.util.concurrent.TimeUnit;

import okio.BufferedSink;
import okio.BufferedSource;
import okio.Okio;
import rx.Observable;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.functions.Func1;
import rx.schedulers.Schedulers;

/**
 * Created by Dong on 16/1/18.
 */
public class WifiSendDataService {
    private String IP;
    private int PORT;

    private WifiSendDataService(String ip,int port){
        IP = ip;
        PORT = port;
    }

    public static WifiSendDataService getProvisionSocket(){
        return new WifiSendDataService("192.168.0.1",5609);
    }

    public static WifiSendDataService getOTASocket(){
        return new WifiSendDataService("192.168.0.1",50007);
    }

    public void sendData(final String data,int retryCount, final int timeOut_second, final DataResponseCallBack dataResponseCallBack, final Class<? extends Response> classOfT){

        Observable.create(new Observable.OnSubscribe<String>() {
            @Override
            public void call(Subscriber<? super String> subscriber) {
                try {
                    String response = sendData(data,timeOut_second);
                    subscriber.onNext(response);
                } catch (Exception e) {
                    Log.e("error", e.getMessage());
                    if (dataResponseCallBack == null)
                        return;
                    dataResponseCallBack.callBack(null);
                }
                subscriber.onCompleted();
            }
        })
                .retry(retryCount)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<String>() {
                    @Override
                    public void onCompleted() {
                    }

                    @Override
                    public void onError(Throwable e) {
                    }

                    @Override
                    public void onNext(String s) {
                        if (dataResponseCallBack == null)
                            return;
                        dataResponseCallBack.callBack(new Gson().fromJson(s, classOfT));
                    }
                });

    }

    private String sendData(String data,int timeOut_second) throws Exception {
        String responseData = null;
        if (data == null || data.length() < 1)
            return null;
        Socket socket = new Socket(IP,PORT);
        BufferedSink sink = Okio.buffer(Okio.sink(socket));
        sink.timeout().timeout(timeOut_second, TimeUnit.SECONDS);
        sink.writeUtf8(data);
        sink.flush();

        BufferedSource buffer = null;
        try {
            buffer = Okio.buffer(Okio.source(socket));
            buffer.timeout().timeout(timeOut_second, TimeUnit.SECONDS);

            //Log.e("resault", "receive net.redbear.redbearduo.data timeoutValueInSeconds  " + timeOut_second);
            String line;
            do {
                line = buffer.readUtf8LineStrict();
                //Log.e("resault", "receive net.redbear.redbearduo.data success  "+line.length());
            } while (line.length() > 0);

            byte[] b = buffer.readByteArray();
//            for (byte bb : b){
//                Log.e("responseQQQ","................  "+bb);
//            }

            //responseData = buffer.readUtf8();
            responseData = new String(b);

            buffer.close();
            return responseData+"";

        }finally {
            if (buffer != null)
                buffer.close();
            socket.close();
        }
    }

    public void sendFile(final InputStream fileStream, final OTAResponseCallBack otaResponseCallBack){

        new Thread(new Runnable() {
            @Override
            public void run() {

                int totalLen = 0;
                try {
                    totalLen = fileStream.available();
                    Log.e("totalLen",totalLen+"");
                } catch (IOException e) {
                    Log.e("fileStream.available()",e.toString());
                    e.printStackTrace();
                }
                int progress = 0;
                int totalProgress = 0;

                try {
                    Socket socket = new Socket(IP,PORT);

                    OutputStream otaOutputStream = socket.getOutputStream();
                    InputStream otaInputStream = socket.getInputStream();

                    byte[] buffer = new byte[100];
                    byte[] send_buffer = new byte[SendFirmwareHead.CHUNK_SIZE];

                    int temp = -1;
                    String response = null;
                    otaOutputStreamSendData(fileStream,otaOutputStream,send_buffer);

                    while((temp = otaInputStream.read(buffer)) != -1){
                        byte[] data = new byte[temp];
                        for(int i = 0; i < data.length;i++) {
                            data[i] = buffer[i];
                        }
                        response = new String(data);
                        if (response.equals("chunk saved")){
                            progress++;
                            int p = progress*100*SendFirmwareHead.CHUNK_SIZE/totalLen;
                            if (totalProgress+10 > p){
                                otaResponseCallBack.callBack(p);
                                totalProgress = p;
                            }
                            otaOutputStreamSendData(fileStream, otaOutputStream,send_buffer);
                        }else if (response.equals("file saved")){
                            otaResponseCallBack.callBack(100);
                            return;
                        }else {
                            //fail
                            return;
                        }
                    }

                } catch (IOException e) {
                    Log.e("sendFile",e.toString());
                    return;
                }
            }
        }).start();
    }

    private void otaOutputStreamSendData(InputStream fileStream,OutputStream otaOutputStream,byte[] buffer) throws IOException {
        int len=-1;
        if ((len=fileStream.read(buffer)) < 0) return;
        if (otaOutputStream != null){
            otaOutputStream.write(buffer,0,len);
            otaOutputStream.flush();
        }
    }

    public interface DataResponseCallBack{
        void callBack(Response data);
    }

    public interface OTAResponseCallBack{
        void callBack(int progress);
    }

}
