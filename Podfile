source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
inhibit_all_warnings!

workspace 'StyledTextKit'

target 'Tests' do
    pod 'Snap.swift', :git => 'https://github.com/skyweb07/Snap.swift.git', :branch => 'feature/fix_image_generation_for_directory_with_spaces'
end

# https://github.com/evgenyneu/Cosmos/issues/105#issuecomment-383402667
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end