# 保留 Flutter 和相关库
-keep class io.flutter.** { *; }
-keep class com.google.gson.** { *; }
-keepattributes *Annotation*

# 保留网络库（如 Dio）
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-keep class retrofit2.** { *; }

# 保留 Google Play Core Library
-keep class com.google.android.play.** { *; }
-keepclassmembers class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**