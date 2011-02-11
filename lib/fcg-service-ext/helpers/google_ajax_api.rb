module FCG
  module GoogleAjaxLibApi
    def load_jquery(debug, jquery_version="1.4.2")
      if debug
        javascript_include_tag "jquery/jquery-#{jquery_version}", "jquery/jquery-ui-1.8.2.custom", "jquery/jquery.getJs"
      else
      <<-HTML
      <script src="#{request.protocol}www.google.com/jsapi"></script>
      <script>
        // <![CDATA[
        google.load("jquery", "#{jquery_version}");
        // ]]>
      </script>
      #{javascript_include_tag "jquery/jquery-ui-1.8.2.custom", "jquery/jquery.getJs", :cache => false}
      HTML
      end
    end

    def load_google_map(key)
      <<-HTML
      <script src="#{request.protocol}maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=#{key}"></script>
      HTML
    end
  end
end