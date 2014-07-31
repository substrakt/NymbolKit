Pod::Spec.new do |s|
  s.name         = 'NymbolKit'
  s.version      = '0.1'
  s.license      =  { :type => 'MIT' }
  s.homepage     = 'http://substrakt.com'
  s.authors      =  { 'Max Woolf' => 'max@substrakt.com' }
  s.summary      = 'Objective-C wrapper around Nymbol'
  s.source = { :git => 'git@github.com:substrakt/NymbolKit.git', :tag => 'master' }
  s.prefix_header_file = "NymbolKit/Supporting Files/NymbolKit-Prefix.pch"
# Source Info
  s.platform     =  :ios, '7.0'
  s.source_files = 'NymbolKit', 'NymbolKit/**', 'NymbolKit/Models/**/*.{h,m}'

  s.requires_arc = true
  s.framework    = 'CoreLocation'
  
# Pod Dependencies
  s.dependency 'Kiwi'
  s.dependency 'AFNetworking'
  s.dependency 'CocoaSecurity'
  s.dependency 'Nocilla'

end
