# app/services/task_bulk_delete_service.rb
module Api
  module V1
    class TaskBulkDeleteService
      def initialize(task_ids, user)
        @task_ids = task_ids
        @user = user
      end

      def call
        return { success: false, errors: ['No task IDs provided'] } if @task_ids.blank?

        tasks = @user.tasks.where(id: @task_ids)
        found_ids = tasks.pluck(:id).map(&:to_s)
        not_found_ids = @task_ids - found_ids

        return { success: false, errors: ["Tasks with IDs #{not_found_ids.join(', ')} not found"] } if not_found_ids.any?

        deleted_count = tasks.destroy_all.count
        { success: true, message: "#{deleted_count} tasks deleted successfully" }
      end
    end
  end
end