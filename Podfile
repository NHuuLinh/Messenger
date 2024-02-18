# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

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
  pod 'MBProgressHUD', '~> 1.2.0'
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
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end
