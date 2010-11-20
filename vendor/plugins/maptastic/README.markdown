# Formtastic Location Selector

## Installation

First, you'll need to install [Formtastic][1].

Next, install Maptastic as a plugin:

    script/plugin install git://github.com/pake007/maptastic.git (for Rails 2)
    rails plugin install git://github.com/pake007/maptastic.git (for Rails 3)


...and run the rake task to install the required js file into your javascripts directory. You will probably need to include this in your layouts, too.

    rake maptastic:install

You'll need to add the [Google Maps **V3**][3] script include in your page, above your semantic_form:

    <script type='text/javascript' src='http://maps.google.com/maps/api/js?sensor=true'></script>

Note that you no longer need an API key with the latest Google Maps release.

## Usage

Maptastic adds a new #multi_input method as well as the map control:

    <% semantic_form_for @venue do |f| %>
      <%= f.multi_input :latitude, :longitude, :as => :map, :zoom => 10 %>
    <% end %>

Note that the map input expects two parameters - a latitude and longitude. The order is important. The option zoom is optional, which defines the size of initial map.

And also, I provide a new public function which can do the simple geocoding work. You can use this function in your js file:

    MaptasticMap.findAddress(address)

This will set your map center to the address you queried, the parameter address can be any of string, like "China, Shanghai, People Square".

## Development

Maybe there will be more functions to added in. Or you can fork and enhance it by yourself, good luck!

## Thanks

This repo is forked from MattHall/maptastic, thanks for his cool work!