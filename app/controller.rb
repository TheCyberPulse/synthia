module Synthia
  class Controller
    Dir.glob(File.dirname(File.absolute_path(__FILE__)) + '/commands/*', &method(:load))

    def call(command_name)
      Kernel.const_get("Synthia::#{command_name}").execute
    end
  end
end
