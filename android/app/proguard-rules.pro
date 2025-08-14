# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# ---- SmartAuth ----
-keep class fman.ge.smart_auth.** { *; }
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.auth.api.** { *; }
-keep class com.google.android.gms.auth.api.credentials.** { *; }

# ---- Razorpay ----
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# ---- Google Pay In-App Payments API ----
-keep class com.google.android.apps.nbu.paisa.inapp.client.api.** { *; }
-keep class com.google.android.gms.wallet.** { *; }
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.**

# ---- Keep annotations ----
-keep class proguard.annotation.** { *; }
-keep @proguard.annotation.Keep class * { *; }
-keepclassmembers class * {
    @proguard.annotation.KeepClassMembers *;
}

# ---- Additional Google Play Services ----
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# ---- Google Play Core (for Flutter deferred components) ----
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-dontwarn com.google.android.play.core.**

# ---- Flutter specific ----
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# ---- Keep all classes with native methods ----
-keepclasseswithmembernames class * {
    native <methods>;
}

# ---- Firebase/Google Services (if needed) ----
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**