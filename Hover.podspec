Pod::Spec.new do |spec|
    spec.name = 'Hover'
    spec.version = '1.0.0'
    spec.license = { :type => 'MIT', :file => 'LICENSE' }
    spec.homepage = 'https://github.com/pedrommcarrasco/Hover'
    spec.authors = { 'Pedro Carrasco' => 'https://twitter.com/pedrommcarrasco' }
    spec.summary = '🎈 Summary'
    spec.source = { :git => 'https://github.com/tonymillion/Hover.git', :tag => spec.version.to_s }
    spec.swift_version = '5.0'

    spec.ios.deployment_target  = '11.0'

    spec.source_files = 'Hover/**/*'
    spec.exclude_files = "Hover/*.plist"

end
