Pod::Spec.new do |spec|
    spec.name                     = 'allshared'
    spec.version                  = '0.1.6'
    spec.homepage                 = 'https://www.touchlab.co'
    spec.source                   = { :http=> ''}
    spec.authors                  = ''
    spec.license                  = 'BSD'
    spec.summary                  = 'KMMBridgeCocoaPodsQuickStart'
    spec.vendored_frameworks      = 'build/cocoapods/framework/allshared.framework'
                
    spec.ios.deployment_target    = '13.5'
                
                
    if !Dir.exist?('build/cocoapods/framework/allshared.framework') || Dir.empty?('build/cocoapods/framework/allshared.framework')
        raise "

        Kotlin framework 'allshared' doesn't exist yet, so a proper Xcode project can't be generated.
        'pod install' should be executed after running ':generateDummyFramework' Gradle task:

            ./gradlew :allshared:generateDummyFramework

        Alternatively, proper pod installation is performed during Gradle sync in the IDE (if Podfile location is set)"
    end
                
    spec.xcconfig = {
        'ENABLE_USER_SCRIPT_SANDBOXING' => 'NO',
    }
                
    spec.pod_target_xcconfig = {
        'KOTLIN_PROJECT_PATH' => ':allshared',
        'PRODUCT_MODULE_NAME' => 'allshared',
    }
                
    spec.script_phases = [
        {
            :name => 'Build allshared',
            :execution_position => :before_compile,
            :shell_path => '/bin/sh',
            :script => <<-SCRIPT
                if [ "YES" = "$OVERRIDE_KOTLIN_BUILD_IDE_SUPPORTED" ]; then
                  echo "Skipping Gradle build task invocation due to OVERRIDE_KOTLIN_BUILD_IDE_SUPPORTED environment variable set to \"YES\""
                  exit 0
                fi
                set -ev
                REPO_ROOT="$PODS_TARGET_SRCROOT"
                "$REPO_ROOT/../gradlew" -p "$REPO_ROOT" $KOTLIN_PROJECT_PATH:syncFramework \
                    -Pkotlin.native.cocoapods.platform=$PLATFORM_NAME \
                    -Pkotlin.native.cocoapods.archs="$ARCHS" \
                    -Pkotlin.native.cocoapods.configuration="$CONFIGURATION"
            SCRIPT
        }
    ]
    spec.libraries = 'c++', 'sqlite3'
    spec.swift_version = "5.0"
end