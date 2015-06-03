module Console; module DefaultCommands
  def self.included(cls)
    cls.instance_eval do

      define_cmd(:help, "show commands") do
        self.class.commands.each do |key, val|
          puts "  #{key}: #{val[:desc]}"
        end
      end

      define_cmd(:exit, "quit client") do
        puts 'good bye!'
        exit
      end

    end
  end
end; end

