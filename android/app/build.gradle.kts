plugins {
    // ✅ ترتيب الإضافات الصحيح
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // مهم لربط Firebase
}

android {
    namespace = "com.example.taskcsc"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.taskcsc"
        minSdk = flutter.minSdkVersion // ✅ ضروري لـ Firebase
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
        multiDexEnabled = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17

        // ✅ كوتلن DSL تحتاج = true بدل من مجرد true
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }

        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ إدارة Firebase عبر BOM
    implementation(platform("com.google.firebase:firebase-bom:33.3.0"))

    // 🔥 المكتبات الأساسية
    implementation("com.google.firebase:firebase-analytics-ktx")
    implementation("com.google.firebase:firebase-firestore-ktx")
    implementation("com.google.firebase:firebase-messaging-ktx")

    // (اختياري) لو استخدمت Auth أو Storage
    // implementation("com.google.firebase:firebase-auth-ktx")
    // implementation("com.google.firebase:firebase-storage-ktx")

    // ✅ تعدد dex
    implementation("androidx.multidex:multidex:2.0.1")

    // ✅ إصلاح flutter_local_notifications (desugaring)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")

    // ✅ دعم WorkManager لإشعارات الخلفية
    implementation("androidx.work:work-runtime-ktx:2.9.0")
}
