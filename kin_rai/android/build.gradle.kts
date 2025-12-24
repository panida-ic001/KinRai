buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.3")
        // เพิ่ม classpath อื่นๆ ถ้าต้องใช้
    }
}

// ถ้าจะให้ subprojects ใช้ repository เดียวกัน (หลาย plugin บางตัวต้องมี)
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ด้านล่างคงเดิม (จัด build dir, task clean ตามที่ Flutter สร้าง)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}