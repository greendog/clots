module Clot
  class Engine < Rails::Engine
    isolate_namespace Clot::Engine

    engine_name :clot

    def self.activate
      %w(
          clot/active_record/droppable.rb
          clot/base_drop.rb
          clot/if_content_for.rb
          clot/date_tags.rb
          clot/deprecated.rb
          clot/form_for.rb
          clot/form_tag.rb
          clot/model_date_tags.rb
          clot/model_form_tags.rb
          clot/mongo_mapper/droppable.rb
          clot/no_model_form_tags.rb
          clot/url_filters.rb
          clot/yield.rb
      ).each do |c|
        Rails.configuration.cache_classes ? require(File.join(Clot::Engine.root, 'lib', c)) : load(File.join(Clot::Engine.root, 'lib', c))
      end

      Liquid::Template.register_filter Clot::UrlFilters
      Liquid::Template.register_filter Clot::LinkFilters
      Liquid::Template.register_filter Clot::FormFilters

      Liquid::Template.register_tag('error_messages_for', Clot::ErrorMessagesFor)
      Liquid::Template.register_tag('formfor', Clot::LiquidFormFor)
      Liquid::Template.register_tag('form_for', Clot::LiquidFormFor)
      Liquid::Template.register_tag('yield', Clot::Yield)
      Liquid::Template.register_tag('if_content_for', Clot::IfContentFor)
      Liquid::Template.register_tag('form_tag', Clot::FormTag)

      Liquid::Template.register_tag('select_tag', Clot::SelectTag)
      Liquid::Template.register_tag('text_field_tag', Clot::TextFieldTag)
      Liquid::Template.register_tag('hidden_field_tag', Clot::HiddenFieldTag)
      Liquid::Template.register_tag('file_field_tag', Clot::FileFieldTag)
      Liquid::Template.register_tag('text_area_tag', Clot::TextAreaTag)
      Liquid::Template.register_tag('submit_tag', Clot::SubmitTag)
      Liquid::Template.register_tag('label_tag', Clot::LabelTag)
      Liquid::Template.register_tag('check_box_tag', Clot::CheckBoxTag)
      Liquid::Template.register_tag('password_field_tag', Clot::PasswordFieldTag)

      Liquid::Template.register_tag('text_field', Clot::TextField)
      Liquid::Template.register_tag('text_area', Clot::TextArea)
      Liquid::Template.register_tag('label', Clot::Label)
      Liquid::Template.register_tag('check_box', Clot::CheckBox)
      Liquid::Template.register_tag('collection_select', Clot::CollectionSelect)
      Liquid::Template.register_tag('file_field', Clot::FileField)
      Liquid::Template.register_tag('password_field', Clot::PasswordField)

      Liquid::Template.register_tag('select_second', Clot::SelectSecond)
      Liquid::Template.register_tag('select_minute', Clot::SelectMinute)
      Liquid::Template.register_tag('select_hour', Clot::SelectHour)

      Liquid::Template.register_tag('select_day', Clot::SelectDay)
      Liquid::Template.register_tag('select_month', Clot::SelectMonth)
      Liquid::Template.register_tag('select_year', Clot::SelectYear)

      Liquid::Template.register_tag('select_date', Clot::SelectDate)
      Liquid::Template.register_tag('select_time', Clot::SelectTime)
      Liquid::Template.register_tag('select_datetime', Clot::SelectDatetime)

      Liquid::Template.register_tag('date_select', Clot::DateSelect)
      Liquid::Template.register_tag('time_select', Clot::TimeSelect)
      Liquid::Template.register_tag('datetime_select', Clot::DatetimeSelect)

      ::ActiveRecord::Base.send(:include, Clot::ActiveRecord::Droppable)
      #::MongoMapper::Document.send(:include, Clot::MongoMapper::Droppable)
    end

    config.to_prepare &method(:activate).to_proc

  end
end
