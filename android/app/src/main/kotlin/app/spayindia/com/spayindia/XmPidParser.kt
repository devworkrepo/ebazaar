package app.spayindia.com.spayindia


import org.xmlpull.v1.XmlPullParser
import org.xmlpull.v1.XmlPullParserException
import org.xmlpull.v1.XmlPullParserFactory
import java.io.IOException
import java.io.StringReader


object XmPidParser {

    @Throws(XmlPullParserException::class, IOException::class)
    fun parse(xml: String?): Array<String> {
        val factory = XmlPullParserFactory.newInstance()
        factory.isNamespaceAware = true
        val xmlPullParser = factory.newPullParser()
        xmlPullParser.setInput(StringReader(xml))
        val respStrings = arrayOf("na", "na")
        var eventType = xmlPullParser.eventType
        while (eventType != XmlPullParser.END_DOCUMENT) {
            if (eventType == XmlPullParser.START_DOCUMENT) {
                println("Start document")
            } else if (eventType == XmlPullParser.START_TAG) {
                if (xmlPullParser.name.equals("Resp", ignoreCase = true)) {
                    val count = xmlPullParser.attributeCount
                    for (i in 0 until count) {
                        val attributeName = xmlPullParser.getAttributeName(i)
                        println(attributeName)
                        if (attributeName.equals("errCode", ignoreCase = true)) {
                            respStrings[0] = xmlPullParser.getAttributeValue(i)
                            println("errCode : " + xmlPullParser.getAttributeValue(i))
                        }
                        if (attributeName.equals("errInfo", ignoreCase = true)) {
                            respStrings[1] = xmlPullParser.getAttributeValue(i)
                            println("errInfo : " + xmlPullParser.getAttributeValue(i))
                        }
                    }
                }
            }
            eventType = xmlPullParser.next()
        }
        return respStrings
    }

    fun getDeviceSerialNumber(data : String) : String {

        var serialNumber = ""
        try {
            val factory =
                    XmlPullParserFactory.newInstance()
            factory.isNamespaceAware = true
            val xpp = factory.newPullParser()
            xpp.setInput(StringReader(data))
            var eventType = xpp.eventType

            var isPidDataTag = false

            while (eventType != XmlPullParser.END_DOCUMENT) {
                when (eventType) {
                    XmlPullParser.START_DOCUMENT -> {

                    }
                    XmlPullParser.START_TAG -> {
                        if(xpp.name=="Data") isPidDataTag = true
                    }
                    XmlPullParser.END_TAG -> {
                        if(xpp.name == "Param"){
                            val name = xpp.getAttributeValue(null,"name")
                            if(name == "srno"){
                                serialNumber = xpp.getAttributeValue(null,"value");
                            }
                        }

                    }
                    XmlPullParser.TEXT -> {
                        /*if(isPidDataTag) {
                            AppLog.d("pidata : ${xpp.text}")
                            isPidDataTag = !isPidDataTag
                        }*/
                    }
                }
                eventType = xpp.next()
            }

        } catch (e: XmlPullParserException) {
            e.printStackTrace()
        } catch (e: IOException) {
            e.printStackTrace()
        }
        finally {
            return serialNumber
        }
    }

}