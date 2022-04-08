package app.spayindia.com.spayindia

import android.content.Intent
import android.widget.Toast
import androidx.annotation.NonNull
import app.spayindia.com.AppConstant
import app.spayindia.com.AppConstant.AEPS_SERVICE_METHOD_NAME
import app.spayindia.com.AppConstant.MATM_SERVICE_METHOD_NAME
import app.spayindia.com.AppConstant.METHOD_CHANNEL
import app.spayindia.com.AppConstant.RD_SERVICE_SERIAL_NUMBER
import app.spayindia.com.XmPidParser
import com.fingpay.microatmsdk.MicroAtmLoginScreen
import com.fingpay.microatmsdk.utils.Constants
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterFragmentActivity() {

    private var result: MethodChannel.Result? = null;


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            METHOD_CHANNEL
        ).setMethodCallHandler { call, rawResult ->

            result = MethodResultWrapper(rawResult)

            when {
                call.method.equals(AEPS_SERVICE_METHOD_NAME) -> {
                    captureAepsPidData(call)
                }
                call.method.equals(MATM_SERVICE_METHOD_NAME) -> {
                    launchMatm(call)
                }
                call.method.equals(RD_SERVICE_SERIAL_NUMBER) -> {
                    try {
                        val mData =
                            XmPidParser.getDeviceSerialNumber(
                                call.argument<String>("pidData") ?: ""
                            )
                        result!!.success(mData)
                    } catch (e: Exception) {
                        result!!.error("0", "Exception raised", e.message)
                    }
                }
            }
        }
    }

    private fun launchMatm(call: MethodCall) {
        try {
            val merchantUserId = call.argument<String>("merchantUserId")
            val merchantPassword = call.argument<String>("merchantPassword")
            val superMerchantId = call.argument<String>("superMerchantId")
            val amount = call.argument<String>("amount")
            val remark = call.argument<String>("remark")
            val mobileNumber = call.argument<String>("mobileNumber")
            val txnId = call.argument<String>("txnId")
            val imei = call.argument<String>("imei")
            val latitude = call.argument<Double>("latitude")
            val longitude = call.argument<Double>("longitude")
            val type = call.argument<Int>("type")


            val intent = Intent(
                this@MainActivity,
                MicroAtmLoginScreen::class.java
            ).apply {
                putExtra(Constants.MERCHANT_USERID, merchantUserId)
                putExtra(Constants.MERCHANT_PASSWORD, merchantPassword)
                putExtra(Constants.SUPER_MERCHANTID, superMerchantId)
                putExtra(Constants.AMOUNT, amount)
                putExtra(Constants.REMARKS, remark)
                putExtra(Constants.MOBILE_NUMBER, mobileNumber)
                putExtra(Constants.AMOUNT_EDITABLE, false)
                putExtra(Constants.TXN_ID, txnId)

                putExtra(Constants.IMEI, imei)
                putExtra(Constants.LATITUDE, latitude)
                putExtra(Constants.LONGITUDE, longitude)
                putExtra(Constants.TYPE, type?.toInt())
            }
            startActivityForResult(intent, AppConstant.MATM_LAUNCH_RESULT_CODE)
        } catch (e: Exception) {
            result?.error(
                "99",
                "Enable to launch Micro-Atm Activity, please contact with admin",
                "exception"
            )
        }
    }

    private fun captureAepsPidData(call: MethodCall) {

        val rdServicePackageUrl = call.argument<String>("packageUrl");
        val isTransaction = call.argument<Boolean>("isTransaction") ?: true
        try {
            val intent = Intent()
            intent.setPackage(rdServicePackageUrl)
            intent.action = AppConstant.Aeps.INTENT_ACTION
            intent.putExtra(
                "PID_OPTIONS",
                if (isTransaction) AppConstant.Aeps.PID_OPTION else AppConstant.Aeps.PID_OPTION_KYC
            )
            startActivityForResult(intent, AppConstant.AEPS_LAUNCH_RESULT_CODE)
        } catch (e: Exception) {
            result?.error(
                "99",
                "Captured failed, please check biometric device is connected",
                "exception"
            )
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (resultCode != RESULT_CANCELED && data != null && resultCode == RESULT_OK) {

            when (requestCode) {
                AppConstant.AEPS_LAUNCH_RESULT_CODE -> handleRDServiceResult(
                    requestCode,
                    resultCode,
                    data
                )
                AppConstant.MATM_LAUNCH_RESULT_CODE -> handleMatmResult(
                    requestCode,
                    resultCode,
                    data
                )
            }
        } else {
            result?.error("101", "Result delivered with black response", "data is null");
        }


    }

    private fun handleRDServiceResult(requestCode: Int, resultCode: Int, data: Intent?) {


        val exceptionMessage = "Captured failed, please check biometric device is connected!";

        val mData = data!!.getStringExtra("PID_DATA")
        if (mData != null) {
            try {
                val respString = XmPidParser.parse(mData)
                if (respString[0].equals("0", ignoreCase = true)) {
                    result!!.success(mData)
                } else {
                    result!!.error("99", exceptionMessage, respString[1])
                }
            } catch (e: java.lang.Exception) {
                result!!.error("99", exceptionMessage, "parsing failed")
            }
        } else {
            result!!.error("99", exceptionMessage, "result is null")
        }
    }

    private fun handleMatmResult(requestCode: Int, resultCode: Int, data: Intent?) {
        val exceptionMessage =
            "Unable to parse result data for micro-atm activity, please contact with admin!";

        try {
            val status: Boolean = data?.getBooleanExtra(Constants.TRANS_STATUS, false) ?: false
            val transAmount: Double = data?.getDoubleExtra(Constants.TRANS_AMOUNT, 0.0) ?: 0.0
            val balAmount: Double = data?.getDoubleExtra(Constants.BALANCE_AMOUNT, 0.0) ?: 0.0
            val bankRrn: String = data?.getStringExtra(Constants.RRN) ?: ""
            val bankName: String = data?.getStringExtra(Constants.BANK_NAME) ?: ""
            val cardNumber: String = data?.getStringExtra(Constants.CARD_NUM) ?: ""
            val message: String = data?.getStringExtra(Constants.MESSAGE) ?: ""
            val time: String = data?.getStringExtra(Constants.TIME_STAMP) ?: ""


            result?.success(
                hashMapOf(
                    "status" to status,
                    "transAmount" to transAmount,
                    "balAmount" to balAmount,
                    "bankRrn" to bankRrn,
                    "bankName" to bankName,
                    "cardNumber" to cardNumber,
                    "message" to message,
                    "time" to time,
                )
            )
        } catch (e: Exception) {
            result?.error(
                "99",
                exceptionMessage,
                "Result not available, please contact with admin"
            )
        }


    }
}
