module Paginatable
  extend ActiveSupport::Concern

  def paginate(paginated)
    {
      current_page: paginated.current_page,
      next_page: paginated.next_page,
      prev_page: paginated.prev_page,
      total_pages: paginated.total_pages,
      total_count: paginated.total_count
    }
  end
end
