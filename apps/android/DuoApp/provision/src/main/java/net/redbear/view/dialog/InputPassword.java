package net.redbear.view.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.text.Editable;
import android.text.InputFilter;
import android.text.Selection;
import android.text.Spanned;
import android.text.TextPaint;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import net.redbear.bleprovision.R;

/**
 * Created by Dong on 16/1/7.
 */
public class InputPassword {
    private Activity mContext;
    private LayoutInflater mInflater;
    private TextView tv_title;
    private Button btn_positive;
    private Button btn_negative;
    private EditText editText;
    private String title;
    Dialog dialog;
    OnDialogCallbackListener listener;

    int passwordMaxLen = 64;
    int passwordMinLen = 8;

    public InputPassword(Activity mContext,String title) {
        this.mContext = mContext;
        this.mInflater=LayoutInflater.from(mContext);
        this.title = title;
        initDialog();

    }

    public void initDialog() {
        View mView = mInflater.inflate(R.layout.dialog_password, null);
        tv_title=(TextView) mView.findViewById(R.id.tv_title);
        TextPaint p = tv_title.getPaint();
        p.setFakeBoldText(true);
        tv_title.setText(title);
        btn_positive=(Button) mView.findViewById(R.id.btn_positive);
        btn_positive.setAlpha(0.3f);
        btn_negative= (Button) mView.findViewById(R.id.btn_negative);
        btn_positive.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (editText.getText().toString().length() >= passwordMinLen){
                    if (listener != null)
                        listener.OnOK(editText.getText().toString());
                    miss();
                }else {
                    Toast.makeText(mContext,"Password must contain at least 8 characters",Toast.LENGTH_SHORT).show();
                }

            }
        });
        btn_negative.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                miss();
            }
        });

        editText = (EditText) mView.findViewById(R.id.dialogpassword);
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                Editable editable = editText.getText();
                int len = editable.length();

                if(len > passwordMaxLen)
                {
                    Toast.makeText(mContext,"Password must not exceed 64 characters",Toast.LENGTH_SHORT).show();
                    int selEndIndex = Selection.getSelectionEnd(editable);
                    String str = editable.toString();
                    String newStr = str.substring(0,passwordMaxLen);
                    editText.setText(newStr);
                    editable = editText.getText();

                    int newLen = editable.length();
                    if(selEndIndex > newLen)
                    {
                        selEndIndex = editable.length();
                    }
                    Selection.setSelection(editable, selEndIndex);

                }
            }

            @Override
            public void afterTextChanged(Editable s) {
                if (s.toString().length() < passwordMinLen) {
                    btn_positive.setAlpha(0.3f);
                }else {
                    btn_positive.setAlpha(1f);
                }
            }
        });

        dialog =new Dialog(mContext,R.style.MyAlertDialog);
        dialog.setContentView(mView);
        dialog.setCanceledOnTouchOutside(false);
        setParams(dialog);
    }

    public void show()	{
        if(dialog !=null)	{
            dialog.show();
        }
    }

    public void miss() {
        if(dialog != null) {
            dialog.dismiss();
        }
    }

    private void setParams(Dialog dialog)	{
        Window dialogWindow = dialog.getWindow();
        WindowManager m = mContext.getWindowManager();
        Display d = m.getDefaultDisplay();
        WindowManager.LayoutParams p = dialogWindow.getAttributes();
        p.width = (int) (d.getWidth() * 0.8);
        p.height= WindowManager.LayoutParams.WRAP_CONTENT;
        dialogWindow.setAttributes(p);
    }

    public void setOnOKdownListener(OnDialogCallbackListener listener){
        this.listener = listener;
    }
    public interface OnDialogCallbackListener{
        void OnOK(String password);
        void OnCancel();
    };

}
