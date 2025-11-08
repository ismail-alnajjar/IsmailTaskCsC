import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

plugins {
    // Plugins الرئيسية للمشروع (تأكد من نفس الإصدارات الموجودة عندك أو قريب منها)
    id("com.android.application") version "8.7.0" apply false
    id("com.android.library") version "8.7.0" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false


}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// هذا الجزء اللي عندك خاص بنقل build directory (يظل كما هو)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
