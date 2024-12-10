# Uncomment the next line to define a global platform for your project
# platform :ios, '15.0'

target 'Messenger' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Messenger
  pod 'FirebaseAuth'
  pod 'Alamofire', '5.8.0'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'Kingfisher'
  pod 'Charts'
  pod 'KeychainSwift'
  pod 'FirebaseDatabase'
  pod 'FirebaseFirestore'
  pod 'MBProgressHUD'
  pod 'Firebase/Storage'

  target 'MessengerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MessengerUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  # Thiết lập IPHONEOS_DEPLOYMENT_TARGET cho tất cả các target
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end

  # Xử lý các cảnh báo trong target BoringSSL-GRPC
  installer.pods_project.targets.each do |target|
    if target.name == 'BoringSSL-GRPC'
      target.source_build_phase.files.each do |file|
        if file.settings && file.settings['COMPILER_FLAGS']
          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
      end
    end
  end
end

