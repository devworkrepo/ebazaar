package app.esmartbazaar.com

import android.content.Context
import android.util.Log
import android.widget.Toast
import app.esmartbazaar.com.BuildConfig

object AppUtil {
    private const val TAG = "Spay Log"
    fun logD(message : Any){
      if(BuildConfig.DEBUG){
          Log.d(TAG, message.toString())
      }
    }
}

fun Context.showToast(message : String) {
    Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
}