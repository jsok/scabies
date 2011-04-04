module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction,
      :state => params[:state], :watching => params[:watching]}
  end

  def bug_list_title
    logger.debug params
    title = ""

    case params[:controller]
    when "user"
      title += "My Bugs"
    when "bugs"
      if params[:project_id]
        title += Project.find_by_permalink(params[:project_id]).name.to_s
      end
    end

    if params[:state]
      title += " -- " + params[:state].titleize + " Bugs"
    else
      if params[:watching]
        title += " -- Watching"
      else
        title += " -- All Bugs"
      end
    end
  end

end
