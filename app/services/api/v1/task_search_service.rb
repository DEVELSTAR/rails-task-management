# app/services/task_search_service.rb
module Api
  module V1
    class TaskSearchService
      def initialize(params, user)
        @params = params
        @user = user
      end

      def call
        tasks = @user.tasks

        tasks = tasks.where(status: @params[:status]) if @params[:status].present?
        
        if @params[:start_date].present? && @params[:end_date].present?
          tasks = tasks.where(due_date: @params[:start_date]..@params[:end_date])
        end
        
        tasks = tasks.where('title ILIKE ?', "%#{@params[:title]}%") if @params[:title].present?

        tasks
      end
    end
  end
end
