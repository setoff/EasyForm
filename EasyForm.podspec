#
# Be sure to run `pod lib lint EasyForm.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "EasyForm"
  s.version          = "0.1.2"
  s.summary          = "UITableView-based declarative form constructor."
  s.description      = <<-DESC
                        `UITableView`-based wrapper for easily creating forms in declarative style.
                       DESC

  s.homepage         = "https://github.com/setoff/EasyForm"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Ilya Sedov" => "i.setoff@gmail.com" }
  s.source           = { :git => "https://github.com/setoff/EasyForm.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/cdog_ya'
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.subspec 'Core' do |core|
    core.source_files = 'EasyForm/Core/**/*.{h,m,c}'
    core.frameworks = 'UIKit'
  end

  s.subspec 'Cells' do |cells|
    cells.source_files = 'EasyForm/Cells/**/*.{h,m,c}'
    cells.frameworks = 'UIKit'
  end

  s.subspec 'Tools' do |tools|
    tools.source_files = 'EasyForm/Tools/**/*.{h,m,c}'
    tools.frameworks = 'UIKit'
  end

end
