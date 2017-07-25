package net.redbear.module.ota;

import android.os.Environment;
import android.util.Log;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipInputStream;
import static net.redbear.module.ota.OTAManage.*;

/**
 * Created by Dong on 16/2/2.
 */
public class LocalFileManage {


    public static String filePath;

    static {
        String status = Environment.getExternalStorageState();
        if (status.equals(Environment.MEDIA_MOUNTED)) {
            filePath = Environment.getExternalStorageDirectory()
                    + "/redbearduo/";
        } else {
            filePath = Environment.getRootDirectory()+ "/redbearduo/";
        }
    }

    public String getLocalFirmwareVersion(){
        File destDir = new File(filePath);
        if (!destDir.exists()) {
            destDir.mkdirs();
            return MIN_VERSION;
        }else {
            File[] files = destDir.listFiles(new FileFilter() {
                @Override
                public boolean accept(File pathname) {
                    if (pathname.getName().endsWith(FIRMWARE_FILE_NAME_END) && pathname.getName().startsWith(FIRMWARE_FILE_NAME_START))
                        return true;
                    return false;
                }
            });
            String newVersion = MIN_VERSION;
            for (File file : files){
                Log.e("files name",file.getName());
                String localversion = getVersionFromFileName(file.getName());
                if (localversion.compareToIgnoreCase(newVersion)>0){
                    newVersion = localversion;
                }
            }
            Log.e("max local version",newVersion);
            return newVersion;
        }
    }
    public int getLocalFirmwareSize(){
        File destDir = new File(filePath);
        if (!destDir.exists()) {
            destDir.mkdirs();
            return 0;
        }else {
            File[] files = destDir.listFiles(new FileFilter() {
                @Override
                public boolean accept(File pathname) {
                    if (pathname.getName().endsWith(FIRMWARE_FILE_NAME_END) && pathname.getName().startsWith(FIRMWARE_FILE_NAME_START))
                        return true;
                    return false;
                }
            });
            String newVersion = MIN_VERSION;
            int size = 0;
            File lastVersionF=null;
            for (File file : files){
                Log.e("files name",file.getName());
                String localversion = getVersionFromFileName(file.getName());
                if (localversion.compareToIgnoreCase(newVersion)>0){
                    newVersion = localversion;
                    lastVersionF = file;
                }
            }
            Log.e("max local version",newVersion);
            if (lastVersionF != null){
                return 0;
            }else {
                return (int)(lastVersionF.length()/1000);
            }
        }
    }

    private String getVersionFromFileName(String fileName){
        if (fileName == null || fileName.length() < 21)
            return MIN_VERSION;
        return fileName.substring(8,fileName.length() - 8);
    }


    public static void upZipFile(File zipFile, String folderPath) throws ZipException, IOException {
        ZipInputStream inZip = new ZipInputStream(new FileInputStream(zipFile));
        ZipEntry zipEntry;
        String szName = "";
        while ((zipEntry = inZip.getNextEntry()) != null) {
            szName = zipEntry.getName();
            if (zipEntry.isDirectory()) {
                // get the folder name of the widget
                szName = szName.substring(0, szName.length() - 1);
                File folder = new File(folderPath + File.separator + szName);
                folder.mkdirs();
            } else {

                File file = new File(folderPath + File.separator + szName);
                file.createNewFile();
                // get the output stream of the file
                FileOutputStream out = new FileOutputStream(file);
                int len;
                byte[] buffer = new byte[1024];
                // read (len) bytes into buffer
                while ((len = inZip.read(buffer)) != -1) {
                    // write (len) byte from buffer at the position 0
                    out.write(buffer, 0, len);
                    out.flush();
                }
                out.close();
            }
        }
        inZip.close();
    }






    public InputStream getBinFromZip(String fileNAme) throws IOException {
        File file = new File(filePath+fileNAme);
        if (file.exists()){
            InputStream inputStream = new FileInputStream(file);
            return inputStream;
        }
        return null;
    }
    public static void clearDir(){
        File root = new File(filePath);
        if (!root.exists()) {
            root.mkdirs();
            return ;
        }
        deleteAllFiles(root);
    }

    public static void deleteAllFiles(File root) {
        File files[] = root.listFiles();
        if (files != null)
            for (File f : files) {
                if (f.isDirectory()) {
                    deleteAllFiles(f);
                    try {
                        f.delete();
                    } catch (Exception e) {
                    }
                } else {
                    if (f.exists()) {
                        deleteAllFiles(f);
                        try {
                            f.delete();
                        } catch (Exception e) {
                        }
                    }
                }
            }
    }
}
