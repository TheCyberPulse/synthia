module Synthia
  class Controller
    Dir.glob(File.dirname(File.absolute_path(__FILE__)) + '/commands/**/*', &method(:load))

    def call(hacker, command_name, input)
      command_name = command_name.to_s.downcase
      command_class = Synthia::Config[:commands][command_name]
      unless command_class.nil?
        return Kernel
          .const_get("Synthia::Command::#{command_class}")
          .execute(hacker, input)
      end
      Synthia::Command::CustomCommand.find_and_execute_command command_name
    end
  end
end
