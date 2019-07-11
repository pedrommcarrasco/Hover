Pod::Spec.new do |s|
  s.swift_version = "5.0"
  s.name         = "Hover"
  s.version      = "1.0.0"
  s.summary      = "🎈"
  s.description  = "🎈"

  s.homepage     = "https://github.com/pedrommcarrasco/Hover
  s.license = { :type => 'MIT', :file => 'LICENSE' }

  s.author    = "Pedro Carrasco"
  s.social_media_url   = "https://twitter.com/pedrommcarrasco"

  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/pedrommcarrasco/Hover.git", :tag => s.version.to_s }

  s.source_files  = "Hover/**/*"
  s.exclude_files = "Hover/*.plist"
end
