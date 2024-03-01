# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
inhibit_all_warnings!

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end

target 'KKPlayer_new' do
  use_frameworks!


  pod 'SnapKit', '5.0.1'
  pod 'IQKeyboardManagerSwift', '6.5.6'
  pod 'ID3TagEditor', '~> 4.0'  
  pod "GCDWebServer/WebUploader"
  

end
