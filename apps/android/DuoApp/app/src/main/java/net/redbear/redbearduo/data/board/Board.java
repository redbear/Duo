package net.redbear.redbearduo.data.board;

import java.util.HashMap;

/**
 * Created by Dong on 15/12/23.
 */
public class Board {
    protected HashMap<Integer,Pin> pins;

    public Board(){
        pins = new HashMap<>();
    }
}
