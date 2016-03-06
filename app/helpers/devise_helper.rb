module DeviseHelper

  def devise_error_messages!
    return "" if resource.errors.empty?
    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <div id="error_explanation">
      <div class="center alert fade in alert-danger">
        <button class="close" data-dismiss="alert">×</button>
        <ul>#{messages}</ul>
      </div>
    </div>
    HTML
    html.html_safe
  end
end
