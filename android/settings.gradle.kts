try {
    val processEnv = Class.forName("java.lang.ProcessEnvironment")

    val envField = processEnv.getDeclaredField("theEnvironment")
    envField.isAccessible = true
    val envMap = envField.get(null) as? MutableMap<*, *>
    envMap?.keys?.removeIf { k -> k.toString().equals("ANDROID_PREFS_ROOT", ignoreCase = true) }

    val ciEnvField = processEnv.getDeclaredField("theCaseInsensitiveEnvironment")
    ciEnvField.isAccessible = true
    val ciEnvMap = ciEnvField.get(null) as? MutableMap<*, *>
    ciEnvMap?.keys?.removeIf { k -> k.toString().equals("ANDROID_PREFS_ROOT", ignoreCase = true) }
} catch (_: Exception) {
}

pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.1.0" apply false
    id("org.jetbrains.kotlin.android") version "2.4.0" apply false
    id("org.gradle.toolchains.foojay-resolver-convention") version "1.0.0"
}

include(":app")
