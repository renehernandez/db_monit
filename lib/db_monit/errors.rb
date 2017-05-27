module DbMonit
  module Errors

    NotValidConfError = Class.new(StandardError)

    CommandNotFoundError = Class.new(StandardError)

    FunctionNotAvailableError = Class.new(StandardError)

  end
end
