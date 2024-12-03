plugins {
    alias(libs.plugins.kotlin.multiplatform)
    alias(libs.plugins.kmmbridge)
    alias(libs.plugins.skie)
    alias(libs.plugins.cocoapods)
    `maven-publish`
}

kotlin {

    listOf(
//        iosX64(),
        iosArm64(),
        iosSimulatorArm64()
    )

    sourceSets {
        commonMain.dependencies {
            implementation(project(":breeds"))
            api(project(":analytics"))
        }
    }

    cocoapods {
        summary = "KMMBridgeCocoaPodsQuickStart"
        homepage = "https://www.touchlab.co"
        ios.deploymentTarget = "13.5"
        extraSpecAttributes["libraries"] = "'c++', 'sqlite3'"
        license = "BSD"
        extraSpecAttributes.put("swift_version", "\"5.0\"") // <- SKIE Needs this!
        framework {
            export(project(":analytics"))
            isStatic = true
        }
    }
}

kmmbridge {
    gitHubReleaseArtifacts()
    // Must be the SSH url
    cocoapods("git@github.com:touchlab/KMMBridgeCocoaTest-releases.git")
}