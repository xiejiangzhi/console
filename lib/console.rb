require "console/version"

require 'readline'

module Console
  def self.included(cls)
    cls.extend(ClassMethods)

    ### default commands ###
    cls.instance_eval do
      define_cmd(:help, "show commands") do
        @commands.each do |key, val|
          puts "  #{key}: #{val[:desc]}"
        end
      end

      define_cmd(:exit, "quit client") do
        puts 'good bye!'
        exit
      end
    end
  end


  module ClassMethods
    def define_cmd(name, desc, &block)
      @commands ||= {}
      @commands[name.to_s] = {desc: desc, block: block}
    end

    def run_cmd(cmd_name, args)
      if @commands[cmd_name]
        @commands[cmd_name][:block].call(*args)
      else
        puts "Invalid command '#{cmd_name}'"
      end
    rescue => e
      puts e.message
    end
  end


  def start(prompt = '> ', hello = nil)
    puts (hello || "use 'help' command show all commands")

    loop do
      cmd_name, *cmd_args = Readline.readline(prompt, true).split

      unless cmd_name
        puts
        next
      else
        self.class.run_cmd(cmd_name, cmd_args)
      end
    end
  end

end
