module Protected
  extend ERB::Util
  extend ActionView::Helpers
  extend ActionView::Context


  class << self
    #include Spree::Core::Engine.routes.url_helpers
    #include Refinery::Core::Engine.routes.url_helpers
    #include Rails.application.routes.url_helpers
    #include ActionView::Helpers::UrlHelper

    def config=(controller)
      @controller = controller
    end

    def config
      @controller
    end

    def controller
      @controller
    end
  end
end
