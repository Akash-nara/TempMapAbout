# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MyMapp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for MyMapp
  pod 'IQKeyboardManagerSwift'
  pod 'Alamofire'
#  pod 'Alamofire', '~> 4.6'
  pod 'SwiftyJSON'
  pod 'SVPinView', '~> 1.0'
  pod 'NVActivityIndicatorView/Extended'
  pod 'CropViewController'
  pod 'WXImageCompress'
  pod 'SKPhotoBrowser'
  pod 'SDWebImage'
  pod 'BottomPopup'
  pod 'WaterfallLayout', '~> 0.1'
  pod 'DKImagePickerController'
  pod "ELWaterFallLayout"
  pod 'CHIPageControl'
  pod 'TagListView'
  pod "CenteredCollectionView"
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'ReachabilitySwift'
  pod 'SkeletonView'
  pod 'Socket.IO-Client-Swift'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      end
    end
  end
  
  target 'MyMappTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'MyMappUITests' do
    # Pods for testing
  end
  
end
