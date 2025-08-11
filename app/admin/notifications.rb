# app/admin/notifications.rb
ActiveAdmin.register Notification do
  actions :all, except: [:new, :show, :edit]

  includes :user, :course

  index do
    selectable_column
    id_column
    column(:description, sortable: false)
    column :user
    column :course
    column :notification_type
    column :read
    column :created_at
    actions defaults: true do |notification|
      if notification.read?
        link_to "Unread", unread_admin_notification_path(notification), method: :put
      else
        link_to "Read", read_admin_notification_path(notification), method: :put
      end
    end
  end

  member_action :read, method: :put do
    resource.update(read: true)
    redirect_to admin_notifications_path, notice: "Marked as read."
  end

  member_action :unread, method: :put do
    resource.update(read: false)
    redirect_to admin_notifications_path, notice: "Marked as unread."
  end

  filter :user
  filter :course
  filter :notification_type
  filter :read
end
