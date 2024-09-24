module Kebab
    module Batches
        class ListHandler < Marten::Handlers::RecordList
            include Auth::RequireSignedInUser
            
            template_name "batches/list.html"
            model Batch
        end
    end
end
