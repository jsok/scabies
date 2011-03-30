module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    if self.respond_to?("sort_column")
      #css_class = column == sort_column ? "current #{sort_direction}" : nil
      direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
      link_to title, {:sort => column, :direction => direction} #,{:class => css_class}
    else
      title
    end
  end
end
