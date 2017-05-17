Pod::Spec.new do |s|
  s.name             = 'BGPickerView'
  s.version          = '0.1.0'
  s.summary          = '自定义PickerView'
  s.description      = "自定义外观的pikcerView，使用方法和UIPikcerView基本一致.主要用途,项目中的选择框,滚筒键盘."
  s.homepage         = 'https://github.com/zhbgitHub/BGPickerView'
  s.license          = "MIT"
  s.author           = { 'zhbgitHub' => 'zhb_mymail@163.com' }
  s.platform         = :ios, "7.0"

  s.source           = { :git => 'https://github.com/zhbgitHub/BGPickerView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.source_files = 'BGPickerView/Classes/**/*'
  s.requires_arc = true
end
