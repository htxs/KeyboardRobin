Pod::Spec.new do |s|

  s.name                    = "KeyboardRobin"
  s.version                 = "0.0.3"
  s.summary                 = "KeyboardRobin help you make keyboard animation."

  s.description             = <<-DESC
                              We may need keyboard infomation from keyboard notification to do animation,
                              but the approach is complicated and easy to make mistakes.
                              But KeyboardRobin will make it simple & easy.
                              DESC

  s.homepage                = "https://github.com/htxs/KeyboardRobin"

  s.license                 = { :type => "MIT", :file => "LICENSE" }

  s.authors                 = { "tianjie" => "gzucm_tianjie@foxmail.com" }

  s.ios.deployment_target   = "6.0"
  s.source                  = { :git => "https://github.com/htxs/KeyboardRobin.git", :tag => s.version }
  s.source_files            = "KeyboardRobin/*.{h,m}"
  s.requires_arc            = true

end
