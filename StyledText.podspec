Pod::Spec.new do |spec|
  spec.name         = 'StyledText'
  spec.version      = '0.1.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/GitHawkApp/StyledText'
  spec.authors      = { 'Ryan Nystrom' => 'rnystrom@whoisryannystrom.com' }
  spec.summary      = 'NSAttributedString building.'
  spec.source       = { :git => 'https://github.com/GitHawkApp/StyledText/StyledText.git', :tag => spec.version.to_s }
  spec.source_files = 'StyledText/*.swift'
  spec.platform     = :ios, '10.0'
end
