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
    minSdk = flutter.minSdkVersion
    targetSdk = 36

    // ⬇️ عدّل فقط هدول السطرين
    versionCode = 2       // زيد الرقم (كان 1)
    versionName = "1.1"   // رقم الإصدار الظاهر للمستخدم

    multiDexEnabled = true
}


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // ✅ Kotlin DSL تحتاج صيغة كاملة:
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        // 🔹 Debug بدون ضغط (عشان التطوير أسرع)
        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }

        // 🔹 Release مضغوط ومهيأ للنشر
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true

            // ✅ ملف proguard لتقليل الحجم بأمان
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            // حالياً يستخدم توقيع debug، ممكن تغيّره لاحقًا بتوقيعك الخاص
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ إدارة Firebase عبر BOM (إصدار موحّد)
    implementation(platform("com.google.firebase:firebase-bom:33.3.0"))

    // 🔥 مكتبات Firebase الأساسية
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
