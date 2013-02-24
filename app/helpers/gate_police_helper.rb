module GatePoliceHelper
  # Check permission
  #
  # @note
  #   You need define check user
  #
  #   @example
  #     alias_method :permission_user, :current_user
  #
  # How to use
  #
  #   @example
  #       class MaterialsController < InheritedResources::Base
  #         before_filter do
  #           require_permission :material, params[:id]
  #         end
  #       end
  #
  # @param  [Symbol]  model_sym   target model and handlers prefix
  # @param  [Integer] object_id   target primary key
  # @raise  [PermissionDenied]    raise for hasn't permissiona
  def require_permission model_sym, object_id=nil
    model_name = "#{model_sym.capitalize.to_s}"
    class_name = "#{model_name}PermissionHandler"
    permission = params[:action].to_sym
    require "#{Rails.root}/app/permissions/application_permission_handler"
    require "#{Rails.root}/app/permissions/#{model_sym.capitalize.to_s}_permission_handler"
    handler = Module.const_get(class_name).new
    handler.user = self.permission_user
    handler.require_permission Module.const_get(model_name), permission, object_id, params
  end

  #
  # Render for permission denied action
  #
  # @note
  #   You need append ApplicationController
  #     rescue_from GatePolice::PermissionDenied, with: :call_denied_action
  #
  # @param  [Exception] exception exception instance
  def call_denied_action exception=nil
    exception.handler.denied_action self
  end
end
