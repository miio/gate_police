module GatePolice 
  # raise for hasn't permission for user
  class PermissionDenied < StandardError
    def initialize(handler)
      super("Permission Denied")
      @handler = handler
    end

    def handler
      @handler
    end
  end
end
