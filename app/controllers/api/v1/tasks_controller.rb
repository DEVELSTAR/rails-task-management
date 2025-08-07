
# app/controllers/api/v1/tasks_controller.rb
module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [ :show, :update, :destroy ]

      def index
        tasks = current_user.tasks.page(params[:page]).per(params[:per_page] || 10)
        render json: TaskSerializer.new(tasks, meta: paginate(tasks)).serializable_hash
      end

      def show
        render json: TaskSerializer.new(@task)
      end

      def create
        task = current_user.tasks.new(task_params)
        if task.save
          render json: TaskSerializer.new(task), status: :created
        else
          render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @task.update(task_params)
          render json: TaskSerializer.new(@task)
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @task.destroy
        head :no_content
      end

      def bulk_destroy
        result = TaskBulkDeleteService.new(params[:task_ids], current_user).call
        if result[:success]
          render json: { message: result[:message] }, status: :ok
        else
          render json: { errors: result[:errors] }, status: :unprocessable_entity
        end
      end

      def delete_all
        tasks = Task.destroy_all

        if tasks.any?
          render json: { message: "All tasks successfully deleted!" }, status: :ok
        else
          render json: { errors: [ "No tasks to delete" ] }, status: :unprocessable_entity
        end
      end

      def search
        tasks = TaskSearchService.new(search_params, current_user).call
        tasks = tasks.page(params[:page]).per(params[:per_page] || 10)
        render json: TaskSerializer.new(tasks, meta: paginate(tasks)).serializable_hash
      end

      private

      def set_task
        @task = current_user.tasks.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Task not found" }, status: :not_found
      end

      def task_params
        params.require(:task).permit(:title, :description, :status, :due_date)
      end

      def search_params
        params.permit(:status, :start_date, :end_date, :title)
      end
    end
  end
end
