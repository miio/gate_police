require "gate_police/version"
require "gate_police/exceptions"
require "gate_police/permission_handler"
#
# Copyright (c) 2013 miio <info@miio.info>
#
module GatePolice
  require "gate_police/engine" if defined?(Rails)
end
