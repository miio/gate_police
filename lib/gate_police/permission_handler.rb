module GatePolice
  # Permission handling classes.
  #
  # Check permission for has_perm? method.
  # Call from require_permission.
  #
  # How call you'r permission handler?
  #
  # @example
  #
  #   class MaterialsController < ApplicationController
  #     require_permission :material
  #   end
  #
  # call MaterialPermissionHandler.
  #
  # How to define permission logic.
  #
  # @example
  #
  #   class MaterialPermissionHandler < ApplicationPermissionHandler
  #       CODE_NAMES = [
  #          :show, :update, :delete
  #       ]
  #   end
  #
  # @note
  #   CODE_NAMES is check target action. if need check permission. You need define action into CODE_NAMES.
  #
  # Permission logic need implements has_perm? method
  #
  # @example
  #
  #   class MaterialPermissionHandler < ApplicationPermissionHandler
  #     CODE_NAMES = [
  #       :show, :update, :delete, :edit
  #     ]
  #     def has_perm? user, code_name, obj, params
  #       # Accept author.
  #       return true if user == obj.user
  #       case code_name
  #       when :show
  #         return true if obj and obj.scope == Material::SCOPE_PUBLIC
  #         return true if obj.scope == Material::SCOPE_GROUP and ProjectMember.where(project_id: obj.project_id, user_id: user.id).first
  #       when :edit, :update, :delete
  #         # Reject guest
  #         return false if user.nil?
  #         # Accept project member if public or group
  #         if obj and (obj.scope == Material::SCOPE_PUBLIC or obj.scope == Material::SCOPE_GROUP)
  #           return true if obj and ProjectMember.where(project_id: obj.project_id, user_id: user.id).first
  #         end
  #       end
  #       false
  #     end
  #   end
  class PermissionHandler
    # Check permission methos.
    # @param [ActiveRecord::Base] model_class check target object class
    # @param [Symbol] permission permission code_name
    # @param [Integer] object_id check target object primary key
    # @param [Hash] params requests
    # @raise [PermissionDenied] raise for hasn't permission
    def require_permission model_class, permission, object_id, params
      return true unless self.class::CODE_NAMES.include? permission
      primary_key = model_class.primary_key
      obj = model_class.where(primary_key => object_id).first_or_initialize
      raise PermissionDenied, self unless self.has_perm? self.user, permission, obj, params
    end

    # Render for PermissionDenied Error
    # @param [ActionController] controller current controller instance
    def denied_action controller
      controller.respond_to do |format|
        format.html { controller.render file: "#{Rails.root}/public/403", handlers: [:html], status: 403, layout: true }
        format.json { controller.render json: { error: true, message: "Permission Denied" } }
      end
    end

    def user
      @user
    end

    def user= user
      @user = user
    end
  end

end
