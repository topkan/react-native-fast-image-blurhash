require 'json'

package = JSON.parse(File.read(File.join(__dir__, '../package.json')))

Pod::Spec.new do |s|
  s.name                = package['name']
  s.version             = "3.2.0"
  s.summary             = package['description']
  s.description         = <<-DESC
                            Fast Image with BlurHash support for React Native
                         DESC
  s.homepage            = "https://github.com/topkan/react-native-fast-image-blurhash"
  s.license             = package['license']
  s.author              = "topkan"
  s.source              = { :git => "git@github.com:topkan/react-native-fast-image-blurhash.git", :tag => "v#{s.version}" }
  s.requires_arc        = true
  s.platform            = :ios, "7.0"
  s.preserve_paths      = "*.framework"
  s.source_files        = 'FastImage/*.{h,m}'
  s.dependency 'React'
end
