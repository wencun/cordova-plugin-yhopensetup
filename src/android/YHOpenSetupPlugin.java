package com.setup.yhck;

import android.Manifest;
import android.content.ContentResolver;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.provider.CallLog;
import android.provider.Settings;
import android.widget.Toast;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class YHOpenSetupPlugin extends CordovaPlugin {
  private CallbackContext mCallbackContext;

  @Override
  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);
  }

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    this.mCallbackContext = callbackContext;
    if (!"".equals(action) || action != null) {
      openSystemSettings();
      return true;
    }
    mCallbackContext.error("error");
    return false;
  }


  /**
   * 小米，没有问题，跳转到页面后直接选择权限管理就可以设置了；
   * vivo，跳转到的权限页面只给看，不能设置；
   * 三星，这一只没问题；
   * oppo，和vivo一样，跳转到的权限页面只给看，不能设置。
   * 其他机型如魅族、HTC不知道情况
   */
  private void openSystemSettings() {
    Intent intent = new Intent();
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    if (Build.VERSION.SDK_INT >= 9) {
      intent.setAction("android.settings.APPLICATION_DETAILS_SETTINGS");
      intent.setData(Uri.fromParts("package", cordova.getActivity().getPackageName(), null));
    } else if (Build.VERSION.SDK_INT <= 8) {
      intent.setAction(Intent.ACTION_VIEW);
      intent.setClassName("com.android.settings", "com.android.settings.InstalledAppDetails");
      intent.putExtra("com.android.settings.ApplicationPkgName", cordova.getActivity().getPackageName());
    }
    cordova.getActivity().startActivity(intent);
    mCallbackContext.success("success");
  }
}
