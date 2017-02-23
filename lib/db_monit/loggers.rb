module DbMonit
  module Loggers

    class EmptyLogger

      def log(arg); end

      def timestamp; end
    end

    class ConsoleLogger

      def log(arg)
        puts arg.to_s
      end

      def timestamp
        puts Time.now
      end

    end

    class FileLogger

      def initialize(path)
        @path = path
      end

      def timestamp
        File.open(@path, "w+") do |f|
          f.puts Time.now
        end
      end

      def log(arg)
        File.open(@path, "w+") do |f|
          f.puts arg
        end
      end
    end
  end
end
