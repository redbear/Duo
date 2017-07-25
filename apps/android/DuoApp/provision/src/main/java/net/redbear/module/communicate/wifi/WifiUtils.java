package net.redbear.module.communicate.wifi;

import android.content.Context;
import android.net.wifi.WifiConfiguration;
import android.net.wifi.WifiManager;
import android.util.Log;

import com.google.common.io.BaseEncoding;

import org.apache.commons.lang3.CharEncoding;

import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.spec.X509EncodedKeySpec;
import java.util.List;

import javax.crypto.Cipher;

/**
 * Created by Dong on 16/1/7.
 */
public class WifiUtils {
    public static final int TYPE_NO_PASSWORD = 0x11;
    public static final int TYPE_WEP = 0x12;
    public static final int TYPE_WPA = 0x13;

    public static void connectToAp(WifiManager wifiManager,String ssid, String password, int type){
        Log.e("1111111", "ssid" + "  " + ssid + "password:  " + password + "type:" + type);
        int wcgID = wifiManager.addNetwork(createWifiInfo(wifiManager,ssid,password,type));
        boolean b = wifiManager.enableNetwork(wcgID, true);
    }

    private static WifiConfiguration createWifiInfo(WifiManager wifiManager,String SSID, String password, int type) {

        WifiConfiguration config = new WifiConfiguration();
        config.allowedAuthAlgorithms.clear();
        config.allowedGroupCiphers.clear();
        config.allowedKeyManagement.clear();
        config.allowedPairwiseCiphers.clear();
        config.allowedProtocols.clear();
        config.SSID = "\"" + SSID + "\"";

        WifiConfiguration tempConfig = IsExsits(wifiManager,SSID);
        if (tempConfig != null) {
            wifiManager.removeNetwork(tempConfig.networkId);
        }

        // 分为三种情况：1没有密码2用wep加密3用wpa加密
        if (type == TYPE_NO_PASSWORD) {// WIFICIPHER_NOPASS
            //config.wepKeys[0] = "";
            config.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.NONE);
            //config.wepTxKeyIndex = 0;

        } else if (type == TYPE_WEP) {  //  WIFICIPHER_WEP
            config.hiddenSSID = true;
            config.wepKeys[0] = "\"" + password + "\"";
            config.allowedAuthAlgorithms
                    .set(WifiConfiguration.AuthAlgorithm.SHARED);
            config.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.CCMP);
            config.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.TKIP);
            config.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.WEP40);
            config.allowedGroupCiphers
                    .set(WifiConfiguration.GroupCipher.WEP104);
            config.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.NONE);
            config.wepTxKeyIndex = 0;
        } else if (type == TYPE_WPA) {   // WIFICIPHER_WPA
            config.preSharedKey = "\"" + password + "\"";
            config.hiddenSSID = true;
            config.allowedAuthAlgorithms
                    .set(WifiConfiguration.AuthAlgorithm.OPEN);
            config.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.TKIP);
            config.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_PSK);
            config.allowedPairwiseCiphers
                    .set(WifiConfiguration.PairwiseCipher.TKIP);
            // config.allowedProtocols.set(WifiConfiguration.Protocol.WPA);
            config.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.CCMP);
            config.allowedPairwiseCiphers
                    .set(WifiConfiguration.PairwiseCipher.CCMP);
            config.status = WifiConfiguration.Status.ENABLED;
        }

        return config;
    }

    private static WifiConfiguration IsExsits(WifiManager wifiManager,String SSID) {
        List<WifiConfiguration> existingConfigs = wifiManager.getConfiguredNetworks();
        for (WifiConfiguration existingConfig : existingConfigs) {
            if (existingConfig.SSID.equals("\"" + SSID + "\"") /*&& existingConfig.preSharedKey.equals("\"" + password + "\"")*/) {
                return existingConfig;
            }
        }
        return null;
    }

    public static String encryptAndEncodeToHex(String inputString, PublicKey publicKey)throws Exception{
        byte[] asBytes = inputString.getBytes(CharEncoding.UTF_8);
        byte[] encryptedBytes = encryptWithKey(asBytes, publicKey);
        String hex = BaseEncoding.base16().encode(encryptedBytes);
        return hex.toLowerCase();
    }

    static byte[] encryptWithKey(byte[] inputData, PublicKey publicKey) throws Exception{
        Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        return cipher.doFinal(inputData);
    }

    public static PublicKey readPublicKeyFromHexEncodedDerString(String hexBytes)
            throws Exception {
        byte[] rawBytes = BaseEncoding.base16().decode(hexBytes);
        return buildPublicKey(rawBytes);
    }

    static PublicKey buildPublicKey(byte[] rawBytes) throws Exception {
        X509EncodedKeySpec spec = new X509EncodedKeySpec(rawBytes);
        KeyFactory kf = KeyFactory.getInstance("RSA");
        return kf.generatePublic(spec);
    }

    static public String packageData(String command,String jsonData){
        StringBuffer data = new StringBuffer(command);
        data.append("\n");
        if (jsonData.length() <= 2){
            data.append(0);
            data.append("\n\n");
        }else {
            data.append(jsonData.length());
            data.append("\n\n");
            data.append(jsonData);
        }
        return data.toString();
    }

    static public String get_phone_connected_ap_ssid(Context context) {
        WifiManager wifiManager = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
        return wifiManager.getConnectionInfo().getSSID();
    }
}
