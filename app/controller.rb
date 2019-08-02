module Synthia
  class Controller
    Dir.glob(File.dirname(File.absolute_path(__FILE__)) + '/commands/**/*', &method(:load))

    def call(hacker, command_name, input)
      command_class = Synthia::Config[:commands][command_name.to_s.downcase]
      return if command_class.nil?
      Kernel.const_get("Synthia::Command::#{command_class}").execute hacker, input
    end
  end
end
