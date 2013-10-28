Pod::Spec.new do |s|
  s.name         = "HIScrollCalendar"
  s.version      = "0.0.1"
  s.summary      = "A simple and beautiful calendar with infinite scrollability."
  s.homepage     = "https://github.com/addsict/HIScrollCalendar"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "Yuuki Furuyama" => "addsict@gmail.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/addsict/HIScrollCalendar.git", :commit => 'master' }
  s.source_files = 'HIScrollCalendar/*.{h,m}'
  s.frameworks = 'QuartzCore'
end
