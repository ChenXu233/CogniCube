import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.cognicube.cognicube"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    // 新增签名配置块（必须在 buildTypes 之前定义）
    signingConfigs {
        create("release") {
            // 从 keystore.properties 加载敏感信息
            val keystoreProperties = rootProject.file("keystore.properties").let {
                Properties().apply { load(it.inputStream()) }
            }

            storeFile = file(keystoreProperties.getProperty("storeFile"))
            storePassword = keystoreProperties.getProperty("storePassword")
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            enableV3Signing = true  // 启用 V3 签名（可选）
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // 定义 Flavor 维度
    flavorDimensions += listOf("impeller_mode")
    productFlavors {
        create("with_impeller") {
            dimension = "impeller_mode"
            manifestPlaceholders["enableImpeller"] = "true"
        }
        create("without_impeller") {
            dimension = "impeller_mode"
            manifestPlaceholders["enableImpeller"] = "false"
        }
    }

    defaultConfig {
        applicationId = "com.cognicube.cognicube"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            isMinifyEnabled = true  // 开启代码混淆
            isShrinkResources = true // 开启资源压缩
            signingConfig = signingConfigs.getByName("release") // 关联签名配置
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.play:core:1.10.3")
    implementation("com.google.android.play:core-ktx:1.8.1")
}