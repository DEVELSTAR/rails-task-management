module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :authenticate_user
      before_action :set_notification, only: [:mark_as_read, :mark_as_unread, :destroy]

      def index
        notifications = current_user.notifications
          .includes(:course)
          .order(created_at: :desc)
          .limit(50)

        render json: notifications.map { |n| serialize(n) }
      end

      def unread
        notifications = current_user.notifications
          .unread
          .includes(:course)
          .order(created_at: :desc)

        render json: notifications.map { |n| serialize(n) }
      end

      def mark_as_read
        @notification.mark_as_read!
        render json: serialize(@notification)
      end

      def mark_as_unread
        @notification.mark_as_unread!
        render json: serialize(@notification)
      end

      def destroy
        @notification.destroy
        render json: { message: "Notification deleted successfully." }
      end

      private

      def set_notification
        @notification = current_user.notifications.find_by(id: params[:id])
        render json: { error: "Notification not found" }, status: :not_found unless @notification
      end

      def serialize(notification)
        {
          id: notification.id,
          message: notification.message,
          notification_type: notification.notification_type,
          course: notification.course&.slice(:id, :title),
          read: notification.read?,
          read_at: notification.read_at,
          created_at: notification.created_at
        }
      end
    end
  end
end
