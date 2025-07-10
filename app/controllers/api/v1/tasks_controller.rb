module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [:show, :update, :destroy]

      def bulk_destroy
        result = TaskBulkDeleteService.new(params[:task_ids]).call
        if result[:success]
          render json: { message: result[:message] }, status: :ok
        else
          render json: { errors: result[:errors] }, status: :unprocessable_entity
        end
      end

      def delete_all_task
        if Task.destroy_all
          render json: { messages: "Task destroyed successfully!" }, status: :ok
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def search
        tasks = TaskSearchService.new(search_params).call
        render json: tasks
      end

      def index
        render json: Task.all, status: :ok
      end

      def show
        render json: @task, status: :ok
      end

      def update
        if @task.update(task_params)
          render json: @task, status: :ok
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if @task.destroy
          render json: { messages: "Task destroyed successfully!" }, status: :ok
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def create
        task = Task.new(task_params)
        if task.save
          render json: task, status: :created
        else
          render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_task
        @task = Task.find(params[:id])
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
