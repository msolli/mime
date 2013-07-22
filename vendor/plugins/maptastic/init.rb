# Include hook code here
require File.join(File.dirname(__FILE__), *%w[lib maptastic-form inputs map_input])
require File.join(File.dirname(__FILE__), *%w[lib maptastic-form inputs base options])
#Formtastic::SemanticFormHelper.builder = MaptasticForm::SemanticFormBuilder