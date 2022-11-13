package com.example.palaemon_passenger_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterAppCompatActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.situm.situm_flutter_wayfinding.SitumMapFactory

class MainActivity: FlutterAppCompatActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // Automatically register plugins:
        super.configureFlutterEngine(flutterEngine)
        // Reguster WYF widget:
        flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory(
                        SitumMapFactory.CHANNEL_ID,
                        SitumMapFactory(flutterEngine.dartExecutor.binaryMessenger, this)
                )
    }
//    private val CHANNEL = "palaemon.situm"
//
//    private val locationListener = object : LocationListener {
//        override fun onLocationChanged(p0: Location) {
//            Log.i("Situm", "onLocationChanged() called with: location = [$p0]")
//        }
//
//        override fun onStatusChanged(p0: LocationStatus) {
//            Log.i("Situm", "onStatusChanged() called with: status = [" + p0 + "]");
//        }
//
//        override fun onError(p0: Error) {
//            Log.e("Situm", "onError() called with: error = [" + p0 + "]")
//        }
//    }
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
//            call, result ->
//            if (call.method == "configure") {
//                Log.i("Situm", "Situm initializing...")
//                SitumSdk.init(this.applicationContext);
//                Log.i("Situm", "Situm initialized...")
//
//                val email = call.argument<String>("email");
//                val apiKey = call.argument<String>("api_key")
//
//                SitumSdk.configuration().setApiKey(email!!, apiKey!!);
//                result.success(true)
//            }
//            if (call.method == "start") {
//                val locationRequest: LocationRequest = LocationRequest.Builder().build()
//                SitumSdk.locationManager().requestLocationUpdates(locationRequest, locationListener);
//                Log.i("Situm", "Situm location update start!")
//
//                result.success(true);
//            }
//            if (call.method == "stop") {
//                SitumSdk.locationManager().removeUpdates(locationListener)
//                Log.i("Situm", "Situm location update start!")
//                result.success(true);
//            }
//        }
//
//
//    }
}
