[![Code Climate](https://codeclimate.com/github/shoponrails/clots.png)](https://codeclimate.com/github/shoponrails/clots)

# Clots

This project seeks to implement extensions for liquid whereby it has the power of other template libraries.

One of the big benefits of liquid is that it enforces a strict MVC paradign where the V cannot affect the M.  This is done for security reasons, but is an excellent approach to coding views in general.  Therefore, we seek to make liquid a fuller template library so it can be used for all views, not just ones that joe user can modify.

## Changes

We have changed the code to be simpler and match the form builders that Rails developers are used to.  Therefore most of the tag names changed to be consistent with the Rails conventions.

Most tags also expect as input either liquid objects, quoted strings, integers, floats, booleans, or arrays.  To simplify arrays, they are expected to be surrounded by brackets and use spaces as delimiters.  An exaple array would be

    [1 true "hello" "world"]

## Links

You now can include an intelligent navigation menu, that allows you to exclude items on-demand (for access control, etc.).  We will document this further, but for the meantime the test cases show how this may be used.

## Form Builder

Clots allows a form to be created like so

    {% error_messages_for pizza %}
    {% form_for pizza %}
        <p>
            {% label "name" %}<br />
            {% text_field "name" %}
        </p>
        <p>
            {% label "crust_type_id" %}
            {% collection_select "crust_type_id", crust_types %}
        </p>

        <p>
            {% check_box "crispy" %}
            {% label "crispy", "Extra Crispy" %}
        </p>

        <h3>Toppings</h3>

        {% for topping in toppings %}
            <p>
                {% check_box_tag 'pizza[topping_ids][]', topping.id, collection:pizza.topping_ids, member:topping.id %}
                {{ topping.name }}
            </p>
        {% endfor %}
        {% hidden_field_tag 'pizza[topping_ids][]', '' %}

        <p>{% submit_tag "Submit" %}</p>
    {% endform_for %}

And generate:

    <form method="POST" action="/pizzas/"><input name="authenticity_token" type="hidden" value="Yaq1/ZWedB7Qg21YZkPibVv9YzfVcY+J4yJRlPrT/Bk="/>
        <p>
            <label for="pizza_name">Name</label><br />
            <input id="pizza_name" name="pizza[name]" type="text" />
        </p>
        <p>
            <label for="pizza_crust_type_id">Crust type</label>
            <select id="pizza_crust_type_id" name="pizza[crust_type_id]"><option value="1">Thin</option><option value="2">Thick</option><option value="3">Deep Dish</option></select>
        </p>

        <p>
            <input name="pizza[crispy]" type="hidden" value="0" /><input id="pizza_crispy" name="pizza[crispy]" type="checkbox" value="1" />
            <label for="pizza_crispy">Extra Crispy</label>
        </p>

        <h3>Toppings</h3>
        <p>
            <input id="pizza[topping_ids][]" name="pizza[topping_ids][]" type="checkbox" value="1" />
            Pepperoni
        </p>
        <p>
            <input id="pizza[topping_ids][]" name="pizza[topping_ids][]" type="checkbox" value="2" />
            Sausage
        </p>

        <p>
            <input id="pizza[topping_ids][]" name="pizza[topping_ids][]" type="checkbox" value="3" />
            Onion
        </p>
        <input id="pizza[topping_ids][]" name="pizza[topping_ids][]" type="hidden" value="" />
        <p><input type="submit" name="commit" value="Submit" /></p>
    </form>


If there were errors, they would both appear at the top of the form and wrap the invalid form items.  You'll note also that CSRF protection is added if enabled.

Note that the interface to this changed and we are currently documenting the improvements.

TODOs
=====

* Major code cleanup
* Tests

Copyright (c) 2008 Ludicast. Alexander Negoda
