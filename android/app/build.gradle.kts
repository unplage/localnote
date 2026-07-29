plugins {
    id("com.android.application")
}

android {
    namespace = "com.localnote.app"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.localnote.app"
        minSdk = 21
        targetSdk = 34
        versionCode = 2
        versionName = "1.2.0"
    }

    buildTypes {
        debug {
            isMinifyEnabled = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

dependencies {
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("androidx.webkit:webkit:1.12.0")
}
