module AdminHelper
  include ActionView::Helpers::DateHelper

  # Returns a human-readable "time ago" string if < 2 days old
  # Otherwise, shows the standard timestamp
  def formatted_time_ago(time)
    return "-" if time.blank?

    if time > 2.days.ago
      "#{time_ago_in_words(time)} ago"
    else
      time.strftime("%B %d, %Y %H:%M")
    end
  end
end
