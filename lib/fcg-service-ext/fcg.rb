module FCG
  module Validation
    BAD_USERNAMES = %w(user users mail login logout new destroy create edit admin ssl xxx sex bitch bitches admin hoe hoes)
    REGEX = {
      :username => /^([a-z0-9][a-z0-9_-]{2,15})$/i,
      :email => /^([\w\!\#$\%\&\'\*\+\-\/\=\?\^\`{\|\}\~]+\.)*[\w\!\#$\%\&\'\*\+\-\/\=\?\^\`{\|\}\~]+@((((([a-z0-9]{1}[a-z0-9\-]{0,62}[a-z0-9]{1})|[a-z])\.)+[a-z]{2,6})|(\d{1,3}\.){3}\d{1,3}(\:\d{1,5})?)$/i
    }
  end
  
  module ACTIVITY
    module VERBS
      # [actor] [verb] [object] [target]
      ALL = {
        :create => "created",
        :join => "joined",
        :make_friend => "made friends with",
        :mark_as_favorite => "marked as favorite",
        :mark_as_liked => "liked",
        :play => "played",
        :post => "posted",
        :save => "saved", 
        :share => "shared", 
        :start_following => "started following",
        :tag => "tagged",
        :update => "updated",
        :view => "viewed",
        :rsvp_yes => "RSVP'd for"
      }
    end
    
    OBJECTS = [
      :article,
      :audio,
      :bookmark,
      :comment,
      :event,
      :file,
      :folder,
      :group,
      :list,
      :note,
      :person,
      :photo,
      :photo_album,
      :place,
      :playlist,
      :product,
      :review,
      :service,
      :status,
      :video
    ]
    
    OBJECT_PROPERTIES = {
      :article => [ :title, :summary, :content, :permalink ],
      :audio => [ :title, :audio_stream, :audio_page_url, :player_applet, :description ],
      :bookmark => [ :title, :description, :target_url, :bookmark_page_url, :target_title, :thumbnail],
      :comment => [:subject, :content, :permalink],
      :event => [:name, :start_date_and_time, :end_date_and_time, :summary],
      :file => [:associated_file_url],
      :folder => [:title, :folder_page_url, :thumbnail],
      :group => [:display_name, :photo],
      :list => [:title, :summary, :permalink],
      :note => [:content, :permalink],
      :person => [:display_name, :photo],
      :photo => [:title, :thumbnail, :larger_image, :image_page_url, :description],
      :photo_album => [:title, :thumbnail, :album_page_url],
      :place => [:name, :geographic_coordinates],
      :playlist => [:title, :thumbnail, :playlist_page_url],
      :product => [:title, :thumbnail, :larger_image, :product_page_url, :description],
      :review => [:title, :content, :permalink, :reviewed_object, :rating],
      :service => [:display_name, :uri, :icon, :photo],
      :status => [:content, :permalink],
      :video => [:title, :thumbnail, :video_stream, :video_page_url, :player_applet, :description]
    }
  end
end
