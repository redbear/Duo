package net.redbear.module.ota;

/**
 * Created by Dong on 16/2/23.
 */
public class OTAManage {

    public static final String FIRMWARE_FILE_NAME_START = "duo_fw_v";
    public static final String FIRMWARE_FILE_NAME_END = "_dfu.zip";
    public static final String MIN_VERSION = "0.0.0";
    public static final String SYSTEM_PART_1_FILE_NAME = "duo-system-part1.bin";
    public static final String SYSTEM_PART_2_FILE_NAME = "duo-system-part2.bin";
    public static final String USER_PART_FILE_NAME = "duo-user-part.bin";


    public static final int OTA_File_STORE_OTA = 0x0;
    public static final int OTA_File_STORE_EAX = 0x1;
    public static final int OTA_REGION_SEC0_ADDR = 0x0;
    public static final int OTA_REGION_SEC1_ADDR = 0x20000;
    public static final int OTA_REGION_SEC2_ADDR = 0x40000;
    public static final int OTA_REGION_SEC3_ADDR = 0x60000;
    public static final int FAC_REGION_ADDR = 0x140000;


}
