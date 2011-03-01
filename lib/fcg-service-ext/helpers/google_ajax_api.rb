module FCG
  module GoogleAjaxLibApi
    def load_jquery(*args)
      opts = args.extract_options!
      opts = { 
        :debug => false,
        :jquery_version => "1.5",
        :jquery_ui_version => "1.8.9"
      }.merge(opts)
      
      if opts[:debug]
        javascript_include_tag "jquery/jquery-#{opts[:jquery_version]}", "jquery/jquery-ui-#{opts[:jquery_ui_version]}.custom", "jquery/jquery.getJs"
      else
      <<-HTML
      <script src="#{request.protocol}www.google.com/jsapi"></script>
      <script>
        // <![CDATA[
        google.load("jquery", "#{opts[:jquery_version]}");
        google.load("jqueryui", "#{opts[:jquery_ui_version]}");
        // ]]>
      </script>
      #{javascript_include_tag "jquery/jquery.getJs", :cache => false}
      HTML
      end
    end

    def load_google_map(key, *args)
      opts = args.extract_options!
      opts = { 
        :url => "maps.google.com/maps",
        :file => "api",
        :v => "2",
        :sensor => "false"
      }.merge(opts)
      
      <<-HTML
      <script src="#{request.protocol}#{opts[:url]}?file=#{opts[:file]}&amp;v=#{opts[:v]}&amp;sensor=#{opts[:sensor]}&amp;key=#{key}"></script>
      HTML
    end
  end
end