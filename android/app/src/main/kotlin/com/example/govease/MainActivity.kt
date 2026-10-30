package com.example.govease

import android.speech.tts.TextToSpeech
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity : FlutterActivity(), TextToSpeech.OnInitListener {
    private val CHANNEL = "com.example.govease/tts"
    private var tts: TextToSpeech? = null
    private var isTtsReady = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "speak" -> {
                    val text = call.argument<String>("text") ?: ""
                    val lang = call.argument<String>("lang") ?: "en-IN"

                    if (tts == null) {
                        tts = TextToSpeech(applicationContext, this)
                    }

                    if (isTtsReady && text.isNotEmpty()) {
                        val locale = when (lang) {
                            "hi-IN" -> Locale("hi", "IN")
                            "ta-IN" -> Locale("ta", "IN")
                            else -> Locale.ENGLISH
                        }
                        tts?.language = locale
                        tts?.setSpeechRate(0.85f)
                        tts?.speak(text, TextToSpeech.QUEUE_FLUSH, null, "GE_TTS")
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
                "stop" -> {
                    try {
                        tts?.stop()
                    } catch (_: Exception) {}
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            isTtsReady = true
        }
    }

    override fun onDestroy() {
        try {
            tts?.stop()
            tts?.shutdown()
        } catch (_: Exception) {}
        super.onDestroy()
    }
}
