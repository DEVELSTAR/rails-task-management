# app/admin/dashboard.rb
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "Dashboard"

  content title: "Admin Dashboard" do
    columns do
      column do
        panel "Courses Overview" do
          table_for Course.all.limit(10).order("created_at desc") do
            column("Name") { |course| link_to course.title, admin_course_path(course) }
            column("Price") { |course| number_to_currency(course.price) }
            column("Modules") { |course| course.course_modules.count }
            column("Students Enrolled") { |course| course.user_course_enrollments.count }
          end
          div { link_to "View All Courses", admin_courses_path }
        end
      end

      column do
        panel "Admin Users" do
          table_for AdminUser.limit(10) do
            column(:email)
            column(:sign_in_count)
            # column("Last Login", &:last_sign_in_at)
          end
        end
      end
    end

    columns do
      column do
        panel "Users & Enrollments" do
          table_for User.limit(10) do
            column(:email)
            column("Enrolled Courses") { |u| u.user_course_enrollments.count }
            column("Completed Courses") { |u| u.user_course_enrollments.where(status: "completed").count }
            column("In Progress") { |u| u.user_course_enrollments.where(status: "in_progress").count }
            column("Courses & Progress") do |u|
            u.user_course_enrollments.includes(:course).map do |enrollment|
                "#{enrollment.course.title}: #{enrollment.progress || 0}%"
            end.join("<br>").html_safe
            end
          end
          div { link_to "View All Users", admin_users_path }
        end
      end
    end
  end
end
