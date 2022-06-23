package app.spayindia.com.spayindia

import android.util.Log
import app.spayindia.com.BuildConfig

object AppUtil {
    private const val TAG = "Spay Log"
    fun logD(message : Any){
      if(BuildConfig.DEBUG){
          Log.d(TAG, message.toString())
      }
    }
}