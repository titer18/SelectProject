Pod::Spec.new do |s|
  s.name             = 'SelectProject'
  s.version          = '1.0'
  s.summary          = 'APP 内选项目'

  #添加第三方依赖
  s.dependency 'QMUIKit'
  s.dependency 'JSONModel'
  s.dependency 'Masonry'
  s.dependency 'PromiseKit', '~> 1.7'
  s.dependency 'MBTips'
  
  <<-DESC
APP 内用到的选项目。
  DESC

  s.homepage         = 'https://github.com/titer18/MBTips'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'titer' => 'zhaohong1991@hotmail.com' }
  s.source           = { :git => 'https://github.com/titer18/SelectProject.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'SelectProject/**/*.{h,m}'
  s.resources    = 'SelectProject/**/*.xib'
  s.public_header_files = 'SelectProject/**/*.h'

end
