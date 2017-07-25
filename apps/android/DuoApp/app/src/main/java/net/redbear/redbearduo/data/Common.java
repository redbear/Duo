package net.redbear.redbearduo.data;

/**
 * Created by Dong on 15/12/23.
 */
public interface Common {
    //connect mode
    String PROVISION_UUID = "3EC61400-89CD-49C3-A0D9-7A85669E901E";
    //String CONTROLLER_UUID = "3EC61400-89CD-49C3-A0D9-7A85669E900E";
    String CONTROLLER_UUID = "713D0000-503E-4C75-BA94-3148F18D941E";
    int CONNECT_STATE_DEFAULT = 0;
    int CONNECT_STATE_PROVISION = 1;
    int CONNECT_STATE_CONTROLLER = 2;

    String MDNS_CONTROLLER_SERVICE_TYPE = "_duocontrol._tcp.";
}
