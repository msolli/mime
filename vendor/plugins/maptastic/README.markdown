# Formtastic Location Selector

## Installation

jQuery & Rails3 & [Formtastic][1] ver 2.0.0.pre & CoffeeScript.


		
You can install this as gem:

    gem install maptastic-form

Also you'll need to copy the JS asset from:

    https://github.com/Kasmanaft/maptastic/blob/master/assets/javascripts/maptastic.js

Or copy CoffeScript from:

    https://github.com/Kasmanaft/maptastic/blob/master/assets/coffeescript/maptastic.coffee

You'll need to add the [Google Maps **V3**][3] script include in your page, above your semantic_form:

    <script type='text/javascript' src='http://maps.google.com/maps/api/js?sensor=true'></script>

Note that you no longer need an API key with the latest Google Maps release.

## Usage

Maptastic adds a new input type:

    <% semantic_form_for @venue do |f| %>
      <%= f.input :your_map, :latitude=>'latitude_field', :longitude=>'longitude_field', :zoom=>'zoom_field', :as => :map %>
    <% end %>

Note that the latitude, longitude and zoom is not . The order is not important.

## Development

This gem is under development. It's pretty simple, and patches are very welcome.

[The Repo is available on GitHub][5]

[Report bugs here][4]

A [testbed app is available][6] to check that the changes made actually work as expected.

## Project Info

Copyright © 2010 [Matthew Hall][2], released under the MIT license.

[1]:http://github.com/justinfrench/formtastic
[2]:http://codebeef.com
[3]:http://code.google.com/apis/maps/documentation/javascript/
[4]:https://matt.purifyapp.com/projects/maptastic/issues
[5]:http://github.com/MattHall/maptastic
[6]:http://github.com/MattHall/maptastic-testbed