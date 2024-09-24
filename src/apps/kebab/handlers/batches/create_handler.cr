module Kebab
  module Batches
    class CreateHandler < Marten::Handlers::RecordCreate
      include Auth::RequireSignedInUser

      model Batch
      schema BatchCreateSchema
      template_name "batches/create.html"
      success_route_name "kebab:list_batches"

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
