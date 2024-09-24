module Management
  module Batches
    class UpdateHandler < Marten::Handlers::RecordUpdate
      include Auth::RequireSignedInUser

      model Batch
      schema BatchUpdateSchema
      template_name "batches/update.html"
      success_route_name "management:list_batches"

      after_successful_schema_validation :add_success_flash
      after_failed_schema_validation :add_error_flash

      private def add_success_flash
        flash[:notice] = "Successfully done!"
      end

      private def add_error_flash
        if schema.errors.any?
          errors = [] of String
          schema.errors.each do |error|
            errors << "#{error.field.try(&.capitalize)}: #{error.message}"
          end
          flash[:error] = errors.try(&.join(", ")) || "An error occurred"
        end
      end
    end
  end
end
