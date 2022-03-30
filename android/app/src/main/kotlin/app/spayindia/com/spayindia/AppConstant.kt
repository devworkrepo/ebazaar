package app.spayindia.com

import android.content.Intent

object AppConstant {


    const val METHOD_CHANNEL = "app.spayindia.com"
    const val AEPS_SERVICE_METHOD_NAME = "launch_aeps_service"
    const val AEPS_LAUNCH_RESULT_CODE = 1000
    const val MATM_SERVICE_METHOD_NAME = "launch_matm_service"
    const val MATM_LAUNCH_RESULT_CODE = 1100




    object Aeps {
        const val PID_OPTION = """<PidOptions ver="1.0">
       <Opts env="P" fCount="1" fType="0" format="0" iCount="0" iType="0" pCount="0" pType="0" pidVer="2.0" posh="UNKNOWN" timeout="10000"/>
    </PidOptions>"""
        const val INTENT_ACTION = "in.gov.uidai.rdservice.fp.CAPTURE"
    }


}