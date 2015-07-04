require "console/version"

require 'readline'

require 'console/default_commands'


module Console
  def self.included(cls)
    cls.extend(ClassMethods)
    cls.include(Console::DefaultCommands)
  end


  module ClassMethods
    def define_cmd(name, desc, &block)
      commands[name.to_s] = {desc: desc, block: block}
    end

    def run_cmd(instance, cmd_name, args = [])
      cmd_name = cmd_name.to_s
      command = commands[cmd_name]

      if command
        instance.instance_exec(*args, &command[:block])
      else
        puts "Invalid command '#{cmd_name}'"
      end
    rescue => e
      puts e.message
    end

    def commands
      @commands ||= {}
    end
  end


  def start(prompt = '> ', options = {})
    puts (options[:hello] || options['hello'] || "use 'help' command show all commands")

    loop do
      cmd_name, *cmd_args = Readline.readline(prompt, true).split

      unless cmd_name
        puts
        next
      else
        self.class.run_cmd(self, cmd_name, cmd_args)
      end
    end
  end
end

