Pod::Spec.new do |s|

  s.name            = "KeyboardRobin"
  s.version         = "0.0.2"
  s.summary         = "KeyboardRobin help you make keyboard animation."

  s.description     = <<-DESC
                      We may need keyboard infomation from keyboard notification to do animation,
                      but the approach is complicated and easy to make mistakes.
                      But KeyboardRobin will make it simple & easy.
                      DESC

  s.homepage        = "https://github.com/gzucm/KeyboardRobin"

  s.license         = { :type => "MIT", :file => "LICENSE" }

  s.authors         = { "tianjie" => "gzucm_tianjie@foxmail.com" }

  s.source          = { :git => "https://github.com/gzucm/KeyboardRobin.git", :tag => s.version }
  s.source_files    = "KeyboardRobin/*.{h,m}"
  s.requires_arc    = true

end
