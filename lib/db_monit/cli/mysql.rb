require 'yaml'

require 'db_monit/errors'
require 'db_monit/loggers'
require 'db_monit/adapters/mysql'
require 'db_monit/cli/base'

module DbMonit
  module CLI

    class Mysql < Base

      desc "status", "Shows the status of the database server"
      option :global, type: :boolean, aliases: :g,
          desc: "Retrieve info from global status instead of session status"
      option :variable, type: :string,
          desc: "Filter the generated status by the given variable"
      def status
        results = @adapter.status(
                        options[:global],
                        options[:variable])

        @logger.timestamp
        results.each {|row| @logger.log(row)}
      end

      desc "threads", "Shows the threads running in the server"
      option :variable, type: :string,
          desc: "Column which will be evaluated with --match option"
      option :match, type: :string,
          desc: "Value to filter for the given --variable"
      def threads
        results = @adapter.threads(
                        options[:variable],
                        options[:match]
                        )

        @logger.timestamp
        results.each {|row| @logger.log(row)}
      end

      desc "watch", "Watch for trigger to occur and collects diagnostic info"
      option :threshold, type: :numeric, default: 20,
          desc: "The max acceptable value for the trigger condition"
      option :cycles, type: :numeric, default: 5,
          desc: "Number of trigger occurrences before collecting data"
      option :interval, type: :numeric, default: 1,
          desc: "Amount of time to wait before checking the trigger condition. Defaults to 1 second"
      option :sleep, type: :numeric, default: 1,
          desc: "Amount of time to wait after diagnostic data have been collected. Defaults to 1 minute"
      option :function, type: :string, default: 'status',
          desc: "Source to trigger the collection of diagnostic data. The --variable option sets the trigger"
      option :variable, type: :string, default: 'Threads_running',
          desc: "The value used to compare against the threshold"
      option :match, type: :string,
          desc: "Value to match the --variable option when function is = threads"
      def watch
        l_watch = lambda do
          cycles = 0
          while true do

            result = if options[:function] == 'status'
                        @adapter.status(true, options[:variable], true)
                    elsif options[:function] == 'threads'
                        @adapter.threads(options[:variable], options[:match], true)
                    else
                      raise FunctionNotAvailableError
                    end

            if result.first['count'].to_i >= options['threshold']
              cycles += 1

              if cycles >= options['cycles']
                results = @adapter.status

                @logger.timestamp
                results.each {|row| @logger.log(row) }
                cycles = 0

                sleep options[:sleep] * 60
                next
              end
            end

            sleep options[:interval]
          end
        end

        if options['deamon']
          pid = Process.fork do
            set_adapter(options)
            l_watch.call
          end

          Process.detach(pid)
        else
          l_watch.call
        end
      end

      private

      def set_adapter(options)
        @adapter = DbMonit::Adapters::Mysql.new(
            host: options['host'],
            username: options['username'],
            password: options['password']
          )
      end

      before_command :status, :threads, :watch

    end
  end
end
