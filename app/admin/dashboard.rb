ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "Dashboard"

  content title: "Admin Dashboard" do
    columns do
      column do
        panel "Courses Overview" do
          table_for Course.order(created_at: :desc)
                          .limit(10) do
            column("Name") { |course| link_to course.title, admin_course_path(course) }
            column("Price") { |course| number_to_currency(course.price) }
            column("Modules") { |course| course.course_modules_count }
            column("Students Enrolled") { |course| course.user_course_enrollments_count }
          end
          div { link_to "View All Courses", admin_courses_path }
        end
      end

      column do
        panel "Admin Users" do
          table_for AdminUser.limit(10) do
            column(:email)
            column(:sign_in_count)
          end
        end
      end
    end

    columns do
      column do
        panel "Users & Enrollments" do
          table_for User.includes(user_course_enrollments: :course).limit(10) do
            column(:email)
            column("Enrolled Courses") { |u| u.user_course_enrollments_count }
            column("Completed Courses") do |u|
              u.user_course_enrollments.select { |e| e.status == "completed" }.size
            end
            column("In Progress") do |u|
              u.user_course_enrollments.select { |e| e.status == "in_progress" }.size
            end
            column("Courses & Progress") do |u|
              u.user_course_enrollments.map do |enrollment|
                "#{enrollment.course.title}: #{enrollment.progress || 0}%"
              end.join("<br>").html_safe
            end
          end
          div { link_to "View All Users", admin_users_path }
        end
      end
    end

    # 📊 Charts Section
    columns do
      column do
        panel "Course Enrollments Chart" do
          render partial: "admin/charts/course_enrollments"
        end
      end

      column do
        panel "Course Completion Chart" do
          render partial: "admin/charts/course_completion"
        end
      end
    end
  end
end
