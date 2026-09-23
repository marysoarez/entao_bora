import java.util.Properties
import java.util.Base64

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Flutter passes --dart-define values to Gradle as comma-separated Base64.
val dartDefines = providers.gradleProperty("dart-defines").orNull
    ?.split(",")
    ?.filter { it.isNotBlank() }
    ?.associate {
        val entry = String(Base64.getDecoder().decode(it), Charsets.UTF_8)
        entry.substringBefore("=") to entry.substringAfter("=", "")
    }.orEmpty()
val localProperties = Properties()
rootProject.file("local.properties").takeIf { it.exists() }?.inputStream()?.use {
    localProperties.load(it)
}
val mapsApiKey = sequenceOf(
    dartDefines["GOOGLE_MAPS_API_KEY"],
    providers.environmentVariable("GOOGLE_MAPS_API_KEY").orNull,
    localProperties.getProperty("GOOGLE_MAPS_API_KEY"),
).mapNotNull { it?.trim()?.takeIf { value -> value.isNotEmpty() } }
    .firstOrNull()
    .orEmpty()

// Diagnostic tasks such as signingReport do not need a Maps key.
// Validate only when building the app, before processing its manifest.
val validateMapsApiKey = tasks.register("validateMapsApiKey") {
    doLast {
        if (mapsApiKey.isEmpty()) {
            throw GradleException(
                "Missing GOOGLE_MAPS_API_KEY. Supply --dart-define=GOOGLE_MAPS_API_KEY=... " +
                    "to Flutter, set the environment variable, or add it to android/local.properties."
            )
        }
    }
}

tasks.named("preBuild") {
    dependsOn(validateMapsApiKey)
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "com.marysoarez.entaobora.entao_bora"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.marysoarez.entaobora.entao_bora"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["mapsApiKey"] = mapsApiKey
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
