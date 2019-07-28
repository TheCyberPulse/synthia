module Synthia
  class Controller
    Dir.glob(File.dirname(File.absolute_path(__FILE__)) + '/commands/*', &method(:load))
    #load File.dirname(File.absolute_path(__FILE__)) + '/commands/hello_world.rb'

    def call(command_name)
      Kernel.const_get("Synthia::#{command_name}").execute
    end
  end
end
