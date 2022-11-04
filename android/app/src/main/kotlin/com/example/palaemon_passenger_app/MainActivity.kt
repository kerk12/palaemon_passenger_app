package com.example.palaemon_passenger_app

import android.util.Log
import es.situm.sdk.SitumSdk
import es.situm.sdk.error.Error
import es.situm.sdk.location.LocationListener
import es.situm.sdk.location.LocationRequest
import es.situm.sdk.location.LocationStatus
import es.situm.sdk.model.location.Location
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "palaemon.situm"

    private val locationListener = object : LocationListener {
        override fun onLocationChanged(p0: Location) {
            Log.i("Situm", "onLocationChanged() called with: location = [$p0]")
        }

        override fun onStatusChanged(p0: LocationStatus) {
            Log.i("Situm", "onStatusChanged() called with: status = [" + p0 + "]");
        }

        override fun onError(p0: Error) {
            Log.e("Situm", "onError() called with: error = [" + p0 + "]")
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "configure") {
                Log.i("Situm", "Situm initializing...")
                SitumSdk.init(this.applicationContext);
                Log.i("Situm", "Situm initialized...")

                val email = call.argument<String>("email");
                val apiKey = call.argument<String>("api_key")

                SitumSdk.configuration().setApiKey(email!!, apiKey!!);
                result.success(true)
            }
            if (call.method == "start") {
                val locationRequest: LocationRequest = LocationRequest.Builder().build()
                SitumSdk.locationManager().requestLocationUpdates(locationRequest, locationListener);
                Log.i("Situm", "Situm location update start!")

                result.success(true);
            }
            if (call.method == "stop") {
                SitumSdk.locationManager().removeUpdates(locationListener)
                Log.i("Situm", "Situm location update start!")
                result.success(true);
            }
        }


    }
}
