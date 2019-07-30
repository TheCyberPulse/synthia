module Synthia
  class Controller
    Dir.glob(File.dirname(File.absolute_path(__FILE__)) + '/commands/*', &method(:load))

    def call(command_name)
      command_class = Synthia::Config[:commands][command_name.downcase]
      Kernel.const_get("Synthia::#{command_class}").execute
    end
  end
end
