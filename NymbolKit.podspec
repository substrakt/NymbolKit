Pod::Spec.new do |s|
  s.name         = 'NymbolKit'
  s.version      = '0.1'
  s.license      =  :type => 'MIT'
  s.homepage     = 'http://substrakt.com'
  s.authors      =  'Max Woolf' => 'max@substrakt.com'
  s.summary      = 'Objective-C wrapper around Nymbol'
  spec.source = { :git => 'git@github.com:substrakt/NymbolKit.git,
                :tag => 'master' }

# Source Info
  s.platform     =  :ios, '7.0'
  s.source_files = 'NymbolKit/**'

  s.requires_arc = true
  s.framework    = 'CoreLocation'
  
# Pod Dependencies
  s.dependencies =	pod 'Kiwi'

end