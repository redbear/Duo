package net.redbear.module.downloader;

import com.google.gson.Gson;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by Dong on 16/2/17.
 */
public class FileDownloader {

    public void download(String urlString,OnDataCallback callback){
        if (urlString == null || urlString.length() == 0)
            return;
        URL url= null;
        try {
            url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection)url.openConnection();
            if (callback != null){
                callback.getData(conn.getInputStream(),conn.getContentLength());
            }
        } catch (Exception e) {
            if (callback != null){
                callback.getDataFail(e);
            }
        }

    }

    public interface OnDataCallback{
        void getData(InputStream t,int len);
        void getDataFail(Exception e);
    }

}
