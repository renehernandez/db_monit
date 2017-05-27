require 'yaml'

module DbMonit
  module CLI
    module Hooks

      def before_command(*method_names)
        method_names.each do |name|
          m = instance_method(name)

          define_method(name) do |*args, &block|
            load_conf(options[:conf], options)
            set_adapter(options)
            set_logger(options[:daemon])
            m.bind(self).call(*args, &block)
          end
        end
      end

    end

    class Base < Thor
      extend Hooks

      class_option :conf, type: :string,
          desc: 'Specifies the path to the configuration file to connect to db server'
      class_option :daemon, type: :boolean, aliases: :d,
          desc: "Runs the command in background and writes the results to file"
      class_option :file, type: :string, aliases: :f,
          desc: "Used in combination with the deamon option, specifies the path to where store the output of the command"
      class_option :username, type: :string,
          desc: "User to connect to database server. Has priority over what is written in conf file"
      class_option :password, type: :string,
          desc: "Password to connect to database server. Has priority over what is written in conf file"
      class_option :host, type: :string, aliases: :f,
          desc: "Host to connect to for the database server. Has priority over what is written in conf file"

      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{subcommand_prefix} #{command.usage}"
      end

      def self.subcommand_prefix
        self.name.gsub(%r{.*::}, '').gsub(%r{^[A-Z]}) { |match| match[0].downcase }.gsub(%r{[A-Z]}) { |match| "-#{match[0].downcase}" }
      end

      private

      def set_logger(daemon)
        @logger = if daemon
                    DbMonit::Loggers::FileLogger.new(options[:file])
                  else
                    DbMonit::Loggers::ConsoleLogger.new
                  end
      end

      def load_conf(conf_file, options)
        data = YAML.load(File.open(conf_file)) if conf_file

        if data
          options[:host] ||= data['host']
          options[:username] ||= data['username']
          options[:password] ||= data['password']
        end

        raise DbMonit::Errors::NotValidConfError  if !%w(host username password).all? { |c| options.key?(c) }
      end

    end
  end
end
