require 'thor'


require 'db_monit/errors'
require 'db_monit/loggers'
require 'db_monit/adapters/mysql'
require 'db_monit/cli/mysql'

module DbMonit
  module CLI

    class Runner < Thor

      desc "mysql SUBCOMMAND ...ARGS", "manage related commands for Mysql servers"
      subcommand :mysql, DbMonit::CLI::Mysql
    end

  end
end
