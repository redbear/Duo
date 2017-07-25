package net.redbear.module.downloader;

import android.util.Log;

import com.google.gson.Gson;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by Dong on 16/2/17.
 */
public class JsonClassDownloader<T> {

    public JsonClassDownloader(){
    }


    public <X> void download(String urlString,OnDataCallback<T> callback,Class<X> classOfX){
        if (urlString == null || urlString.length() == 0)
            return;
        URL url= null;
        try {
            url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection)url.openConnection();

            InputStream input = conn.getInputStream();
            BufferedReader in=new BufferedReader(new InputStreamReader(input));
            String line=null;
            StringBuffer sb=new StringBuffer();
            while((line=in.readLine())!=null){
                sb.append(line);
            }
            if (callback != null){
                callback.getData((T)new Gson().fromJson(sb.toString(),classOfX));
            }
        } catch (Exception e) {
            if (callback != null){
                callback.getDataFail(e);
            }
        }

    }

    public interface OnDataCallback<T>{
        void getData(T t);
        void getDataFail(Exception e);
    }

}
