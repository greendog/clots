require 'clot/url_filters'
require 'clot/link_filters'
require 'clot/form_filters'
require 'clot/tag_helper'

module Clot
  class LiquidForm < Liquid::Block
    include UrlFilters
    include LinkFilters
    include FormFilters
    include TagHelper

    Syntax = /([^\s]+)\s+/

    def initialize(tag_name, markup, tokens)
      if markup =~ Syntax
        @form_object = $1
        @attributes = {}
        markup.scan(Liquid::TagAttributes) do |key, value|
          @attributes[key] = value
        end
      else
        syntax_error# tag_name, markup, tokens
      end
      super
    end

    def render(context)
      set_variables context
      render_form context
    end

    def render_form(context)
      result = get_form_header(context)
      result += get_form_body(context)
      result += get_form_footer
      result
    end

    def syntax_error
      raise SyntaxError.new("Syntax Error in form tag")
    end

    def get_form_body(context)
      context.stack do
        render_all(@nodelist, context) * ""
      end
    end

    def get_form_footer
      "</form>"
    end

    def set_upload
      if @attributes["uploading"] || @attributes["multipart"] == "true"
        @upload_info = ' enctype="multipart/form-data"'
      else
        @upload_info = ''
      end
    end

    def set_variables(context)
      set_controller_action
      set_form_action(context)
      set_upload
    end

  end

  # Resource-oriented style
  # For example, if post is an existing record you want to edit
  # form_for @post is equivalent to something like:
 # {% form_for post  as:post  url_helper:post_path  method:put  html:{ :class => "edit_post", :id => "edit_post_45" } %}
  class LiquidFormFor < LiquidForm

    def initialize(tag_name, markup, tokens)
      if markup =~ Syntax
        @form_object = $1
        @attributes = {}
        markup.scan(Liquid::TagAttributes) do |key, value|
          @attributes[key] = value
        end
      else
        syntax_error# tag_name, markup, tokens
      end
      super
    end


    def render(context)
      if @attributes.has_key?('url_helper')
        Protected.config = context.registers[:controller]
        @attributes['url'] = Protected.send(@attributes['url_helper'].to_sym) unless @attributes.has_key?('url_helper_params')
        if params = context[@attributes['url_helper_params']]
          arg = params.is_a?(String) ? params : params.source
          @attributes['url'] = Protected.send(@attributes['url_helper'].to_sym, arg)
        end

      end

      if @attributes.has_key?('html')
        @attributes['html'] = eval(@attributes['html'].chomp('"').reverse.chomp('"').reverse)
      end

      @attributes.except!('url_helper').except!('url_helper_params')

      item = context[@form_object].to_sym if context[@form_object].is_a?(String)
      item = context[@form_object].source if context[@form_object].is_a?(Liquid::Drop)

      context.registers[:action_view].form_for(item, @attributes.symbolize_keys) do |form|
        set_model(context)
        set_upload
        context.stack do
          context['form'] = form
          get_form_body(context).html_safe
        end

      end
    end

    def get_form_body(context)
      context.stack do
        context['form_model'] = @model
        context['form_class_name'] = @class_name
        context['form_errors'] = []
        @model.errors.each do |attr, msg|
          context['form_errors'] << attr
        end if @model.respond_to? :errors
        return render_all(@nodelist, context)
      end
    end


    private

    def set_controller_action
      silence_warnings {
        if (@model.nil? || @model.source.nil?) && @model.source.new_record?
          @activity = "new"
        else
          @activity = "edit"
        end
      }
    end

    def set_form_action(context)
      if @attributes.has_key?('ur_helper')
        Protected.config = context.registers[:controller]

        if @attributes['object'].nil?
          @form_action = Protected.send(@attributes['ur_helper'].to_sym) || 'not found'
        else
          @form_action = Protected.send(@attributes['ur_helper'].to_sym, @attributes['object'].source) || 'not found'
        end
      elsif @attributes.has_key?('ur')
        @form_action = @attributes['url']
      else
        if @activity == "edit"
           @form_action = object_url @model
        elsif @activity == "new"
          @form_action = "/" + @model.dropped_class.to_s.tableize.pluralize
        else
          syntax_error
        end
      end
    end

    def set_model(context)
      @model = context[@form_object] || nil
      if not @model
        @model = @form_object.classify.constantize.new.to_liquid
        if @model.source.new_record?
          @model.defaults(context)
          context[@form_object] = @model
        end
      end
    end


    def set_variables(context)
      set_model(context)
      super
    end

  end


  class ErrorMessagesFor < Liquid::Tag

    include TagHelper

    def initialize(name, params, tokens)
      @_params = split_params(params)
      super
    end


    def render(context)
      @params = @_params.clone
      @model = context[@params.shift]

      result = ""
      if @model and @model.respond_to?(:errors) and @model.errors.count > 0
        @suffix = @model.errors.count > 1 ? "s" : ""
        @default_message = @model.errors.count.to_s + " error#{@suffix} occurred while processing information"

        @params.each do |pair|
          pair = pair.split /:/
          value = resolve_value(pair[1], context)

          case pair[0]
            when "header_message" then
              @default_message = value
          end
        end

        result += '<div class="errorExplanation" id="errorExplanation"><h2>' + @default_message + '</h2><ul>'

        @model.errors.each do |attr, msg|
          result += "<li>#{error_message(attr, msg)}</li>"
        end if @model.respond_to? :errors

        result += "</ul></div>"
      end
      result
    end

    def error_message(attr, msg)
      unless attr == :base
        "#{attr} - #{msg}"
      else
        msg
      end
    end

  end

end
