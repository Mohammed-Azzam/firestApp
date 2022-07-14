package com.flasherCheetah.speedAndSuccess.speed_and_success

import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import android.view.WindowManager.LayoutParams
import io.flutter.embedding.engine.FlutterEngine
import android.os.Bundle; // required for onCreate parameter
import androidx.core.content.ContextCompat
import androidx.core.content.ContextCompat.startActivity
import com.scottyab.rootbeer.RootBeer
import java.io.File
import java.lang.Exception


//private val BASE64_PUBLIC_KEY =
//    "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnVzNjDzqBXWHmizY2HHJQTWOegq10lkA7zxsisQHP/kQmZ3c5DYFx9o5EtFFoOwJu3dSF/wxwOzKHlvQhvCVi85kZzcrKKihCi7CtO5g7Tuf8d1zz0EyQjGpR7NHerba0DVwsWDICEvRzMcqHJZTj5zUfd/io7NiMy+UzQwWi4JrUNePlvmgKx9hgWL/hGjX7tEYKn+EXnlmr46YlMk3cwb0dshezA6h8xFyxtbQP2ICKeJiIw/zmhvMCYxN9qfYrMHwBWjqHTlAFIaIskdS8WYv8f1BTHGXOyQCe6I8Z8olq8zHqMpVk0Uy6OiR1w+xXrZUtA7QJFzRhg7JXxD0GQIDAQAB";
//
//    private val mHandler: Handler? = null
//private val mChecker: LicenseChecker? = null
//private val mLicenseCheckerCallback: LicenseCheckerCallback? = null
//var licensed = false
//var checkingLicense = false
//var didCheck = false
//
//private fun doCheck() {
//    didCheck = false
//    checkingLicense = true
//    setProgressBarIndeterminateVisibility(true)
//    mChecker.checkAccess(mLicenseCheckerCallback)
//}
//

class MainActivity : FlutterActivity() {
//    { 29, 71, 02, 50, 0, 46, 98, 56, 25, 88, 99, 15, 44, 0, 59, 27, 52, 18, 51, 62 }

    fun showAlertDialogAndExitApp(message: String?) {
        val alertDialog = AlertDialog.Builder(this@MainActivity).create()
        alertDialog.setTitle("Alert")
        alertDialog.setMessage(message)
        alertDialog.setButton(
            AlertDialog.BUTTON_NEUTRAL, "OK"
        ) { dialog, which ->
            dialog.dismiss()
            val intent = Intent(Intent.ACTION_MAIN)
            intent.addCategory(Intent.CATEGORY_HOME)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            startActivity(intent)
            finish()
        }
        alertDialog.show()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.addFlags(LayoutParams.FLAG_SECURE);
        val rootBeer = RootBeer(context)
        if (rootBeer.isRooted()) {
            //we found indication of root
            window.addFlags(LayoutParams.FLAG_SECURE);
//            showAlertDialogAndExitApp("This device is rooted. You can't use this app.")

        } else {
            //we didn't find indication of root
        }
//        if (DeviceUtils().isDeviceRooted(applicationContext)) {
//           }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        window.addFlags(LayoutParams.FLAG_SECURE)
        super.configureFlutterEngine(flutterEngine)
    }

    override fun onResume() {
        super.onResume()
        val rootBeer = RootBeer(context)
        if (rootBeer.isRooted()) {
            //we found indication of root
            window.addFlags(LayoutParams.FLAG_SECURE);
//            showAlertDialogAndExitApp("This device is rooted. You can't use this app.")

        } else {
            //we didn't find indication of root
        }
//        if (DeviceUtils().isDeviceRooted(applicationContext)) {
//
//        }
    }

}


class DeviceUtils {
    fun isDeviceRooted(context: Context?): Boolean {
        return isrooted1() || isrooted2()
    }

    private fun isrooted1(): Boolean {
        val file = File("/system/app/Superuser.apk")
        return file.exists()
    }

    // try executing commands
    private fun isrooted2(): Boolean {
        return (canExecuteCommand("/system/xbin/which su")
                || canExecuteCommand("/system/bin/which su")
                || canExecuteCommand("which su"))
    }

    private fun canExecuteCommand(command: String): Boolean {
        val executedSuccesfully: Boolean = try {
            Runtime.getRuntime().exec(command)
            true
        } catch (e: Exception) {
            false
        }
        return executedSuccesfully
    }

}


//
//private class MyLicenseCheckerCallback : LicenseCheckerCallback {
//    fun allow(reason: Int) {
//        // TODO Auto-generated method stub
//        if (isFinishing()) {
//            // Don't update UI if Activity is finishing.
//            return
//        }
//        Log.i("License", "Accepted!")
//
//        //You can do other things here, like saving the licensed status to a
//        //SharedPreference so the app only has to check the license once.
//        licensed = true
//        checkingLicense = false
//        didCheck = true
//    }
//
//    fun dontAllow(reason: Int) {
//        // TODO Auto-generated method stub
//        if (isFinishing()) {
//            // Don't update UI if Activity is finishing.
//            return
//        }
//        Log.i("License", "Denied!")
//        Log.i("License", "Reason for denial: $reason")
//
//        //You can do other things here, like saving the licensed status to a
//        //SharedPreference so the app only has to check the license once.
//        licensed = false
//        checkingLicense = false
//        didCheck = true
//        showDialog(0)
//    }
//
//    fun applicationError(reason: Int) {
//        // TODO Auto-generated method stub
//        Log.i("License", "Error: $reason")
//        if (isFinishing()) {
//            // Don't update UI if Activity is finishing.
//            return
//        }
//        licensed = true
//        checkingLicense = false
//        didCheck = false
//        showDialog(0)
//    }
//}
//
//fun onCreateDialog(id: Int): Dialog {
//    // We have only one dialog.
//    return Builder(this)
//        .setTitle("UNLICENSED APPLICATION DIALOG TITLE")
//        .setMessage("This application is not licensed, please buy it from the play store.")
//        .setPositiveButton("Buy", DialogInterface.OnClickListener { dialog, which ->
//            val marketIntent = Intent(
//                Intent.ACTION_VIEW, Uri.parse(
//                    "http://market.android.com/details?id=" + getPackageName()
//                )
//            )
//            startActivity(marketIntent)
//            finish()
//        })
//        .setNegativeButton("Exit", DialogInterface.OnClickListener { dialog, which -> finish() })
//        .setNeutralButton("Re-Check", DialogInterface.OnClickListener { dialog, which -> doCheck() })
//        .setCancelable(false)
//        .setOnKeyListener(DialogInterface.OnKeyListener { dialogInterface, i, keyEvent ->
//            Log.i("License", "Key Listener")
//            finish()
//            true
//        })
//        .create()
//}
