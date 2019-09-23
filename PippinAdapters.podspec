Pod::Spec.new do |s|
  s.name         = 'PippinAdapters'
  s.version      = '4.0.0'
  s.summary      = "Plugins for Pippin Protocols."
  s.description  = <<-DESC
                   A collection of pluggable adapters to third-party dependencies, or entirely self-rolled implementations for Pippin protocols.
                   DESC
  s.homepage     = 'http://github.com/tworingsoft/Pippin'
  s.license      = 'MIT'
  s.author       = { 'Andrew McKnight' => 'andrew@tworingsoft.com' }
  s.source       = { :git => 'https://github.com/tworingsoft/Pippin.git', :tag => "#{s.name}-#{s.version}" }
  s.platform     = :ios, '9.0'
  s.swift_version = '5.1'

  s.source_files = 'Sources/PippinAdapters/*.{h,m,swift}'
  
  s.default_subspecs = 'PinpointKit', 'COSTouchVisualizer', 'XCGLogger', 'SwiftMessages', 'JGProgressHUD', 'CRUDViewController', 'InfoViewController', 'CoreData'

  s.subspec 'PinpointKit' do |ss|
    ss.source_files = 'Sources/PippinAdapters/PinpointKit/**/*.{h,m,swift}'
    ss.dependency 'PinpointKit', '~> 1'
    ss.dependency 'PippinCore'
  end
  s.subspec 'COSTouchVisualizer' do |ss|
    ss.source_files = 'Sources/PippinAdapters/COSTouchVisualizer/**/*.{h,m,swift}'
    ss.dependency 'COSTouchVisualizer', '~> 1'
    ss.dependency 'PippinCore'
  end
  s.subspec 'XCGLogger' do |ss|
    ss.source_files = 'Sources/PippinAdapters/XCGLogger/**/*.{h,m,swift}'
    ss.dependency 'XCGLogger', '~> 7'
    ss.dependency 'PippinCore'
  end
  s.subspec 'SwiftMessages' do |ss|
    ss.source_files = 'Sources/PippinAdapters/SwiftMessages/**/*.{h,m,swift}'
    ss.dependency 'SwiftMessages', '~> 7'
    ss.dependency 'PippinCore'
  end
  s.subspec 'JGProgressHUD' do |ss|
    ss.source_files = 'Sources/PippinAdapters/JGProgressHUD/**/*.{h,m,swift}'
    ss.dependency 'PippinCore'
    ss.dependency 'JGProgressHUD', '~> 2'
  end
  s.subspec 'CRUDViewController' do |ss|
    ss.source_files = 'Sources/PippinAdapters/CRUDViewController/**/*.{h,m,swift}'
    ss.dependency 'PippinCore'
    ss.dependency 'PippinLibrary'
  end
  s.subspec 'InfoViewController' do |ss|
    ss.source_files = 'Sources/PippinAdapters/InfoViewController/**/*.{h,m,swift}'
    ss.dependency 'PippinCore'
    ss.dependency 'PippinLibrary'
  end
  s.subspec 'FormController' do |ss|
    ss.source_files = 'Sources/PippinAdapters/FormController/**/*.{h,m,swift}'
    ss.dependency 'PippinCore'
    ss.dependency 'PippinLibrary'
  end
  s.subspec 'CoreData' do |ss|
    ss.source_files = 'Sources/PippinAdapters/CoreData/**/*.{h,m,swift}'
    ss.dependency 'PippinCore'
    ss.dependency 'PippinLibrary'
  end
  s.subspec 'CoreLocation' do |ss|
    ss.source_files = 'Sources/PippinAdapters/CoreData/**/*.{h,m,swift}'
    ss.dependency 'PippinCore'
    ss.dependency 'PippinLibrary'
  end
end
