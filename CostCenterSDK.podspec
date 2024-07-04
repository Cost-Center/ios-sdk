Pod::Spec.new do |spec|
  spec.name          = 'CostCenterSDK'
  spec.version       = '1.0.1'
  spec.homepage      = 'https://github.com/Cost-Center/ios-sdk'
  spec.license        = { :type => 'MIT', :file => 'MIT-LICENSE.txt' }
  spec.authors      = { 'Ho Van Ngan' => 'nganhopro2010@gmail.com' }
  spec.summary       = 'This is the iOS SDK of Cost Center. You can read more about it at https://www.costcenter.net'
  spec.source        = { :git => 'https://github.com/Cost-Center/ios-sdk.git', :tag => spec.version }
  spec.dependency 'FirebaseCore'
  spec.dependency 'Firebase/Installations'
  spec.module_name   = 'CostCenterSDK'
  spec.swift_version = '5.10'
  spec.ios.deployment_target  = '12.0'
  spec.source_files = 'CostCenterSDK/**/*.swift'
  spec.resource_bundles = {
    "#{spec.module_name}_Privacy" => 'CostCenterSDK/**/*.xcprivacy'
  }

end