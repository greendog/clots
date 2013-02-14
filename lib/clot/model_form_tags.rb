module Clot
  module ModelTag
    def set_primary_attributes(context)
      @item = context['form_model']
      if @item

        @attribute_name =  resolve_value(@params.shift,context)
        @first_attr = context['form_class_name']
      else
        @first_attr =  @params.shift

        if @params[0] && ! @params[0].match(/:/)
          @attribute_name =  resolve_value(@params.shift,context)
        end
        @item = context[@first_attr]
      end
      attribute_names = @attribute_name.split('.')

      unless @item.source.respond_to?(:"#{attribute_names[0]}=")
        raise "#{attribute_names[0]} is not a valid form field for #{@first_attr.camelize}."
      end

      if attribute_names.size == 3
        @name_string = @first_attr + "[" + attribute_names[0].to_s + "_attributes][" + attribute_names[1].to_s + "_attributes][" + attribute_names[2].to_s + "]"
        @id_string = @first_attr + "_" + attribute_names[0].to_s + "_attributes_" + attribute_names[1].to_s + "_" + attribute_names[2].to_s
        @value_string = ""
        if @item
          @subitem = @item[attribute_names[0]][attribute_names[1]]
          if @subitem
            @value_string = @subitem[attribute_names[2].to_sym]
          end
        end
      elsif attribute_names.size == 2
        @name_string = @first_attr + "[" + attribute_names[0].to_s + "_attributes][" + attribute_names[1].to_s + "]"
        @id_string = @first_attr + "_" + attribute_names.join('_')
        @value_string = ""
        if @item
          @subitem = @item[attribute_names[0]]
          if @subitem
            @value_string = @subitem[attribute_names[1].to_sym]
          end
        end
      else
        @id_string = "#{@first_attr}_#{@attribute_name}"
        @name_string = "#{@first_attr}[#{@attribute_name}]"
        @value_string = @item[@attribute_name.to_sym]
      end
      @errors = context['form_errors'] || []

    end

    def render(context)
      super(context)
    end

  end

 class FileField < FileFieldTag
   include ModelTag

   def render_string
     @value_string = nil
     super
   end
 end

  class PasswordField < PasswordFieldTag
    include ModelTag
  end

  class TextField < TextFieldTag
    include ModelTag
  end
  class TextArea < TextAreaTag
    include ModelTag
  end

  class Label < LabelTag
    include ModelTag

    def get_label_for(label)
      label.humanize
    end

    def set_primary_attributes(context)
      super context
      if @params[0] && ! @params[0].match(/:/)
        @value_string = resolve_value(@params.shift,context)
      else
        @value_string = get_label_for(@attribute_name)
      end
    end
  end

  class CollectionSelect < ClotTag
    # usage:
    # {% collection_select "order[bill_address_attributes]" method:"country_id", collection:available_countries, value_method:'id', text_method:'name', html_options:"{class:'large-field'}" %}

    def render(context)
      super(context)

      # collection_select(object, method, collection, value_method, text_method, options = {}, html_options = {})
      method = @attributes['method']
      collection = @attributes['collection']
      value_method = @attributes['value_method']
      text_method = @attributes['text_method']
      @attributes.has_key?('options') ? options = @attributes['options'] : options = {}
      @attributes.has_key?('html_options') ? html_options = @attributes['html_options'] : html_options = {}


      context.registers[:action_view].collection_select(@form_object, method, collection, value_method, text_method, options, html_options)
    end
  end

  class CheckBox < ClotTag
    include ModelTag

    def set_primary_attributes(context)
      super(context)
      if @params.length > 1 && ! @params[0].match(/:/) && ! @params[1].match(/:/)
        @true_val = resolve_value(@params.shift,context)
        @false_val = resolve_value(@params.shift,context)
      else
        @true_val = 1
        @false_val = 0
      end
    end

    def render_string
      if @item[@attribute_name.to_sym]
        @checked_value = %{checked="checked" }
      end
      %{<input name="#{@name_string}" type="hidden" value="#{@false_val}" />} + %{<input #{@disabled_string}#{@class_string}#{@checked_value}id="#{@id_string}" name="#{@name_string}" type="checkbox" value="#{@true_val}" />}
    end
  end

end
