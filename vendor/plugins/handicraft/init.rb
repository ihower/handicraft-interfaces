ActionView::Helpers::AssetTagHelper::JAVASCRIPT_DEFAULT_SOURCES = ['jquery','jquery-ui','jquery.metadata','jquery.form','handicraft']
ActionView::Helpers::AssetTagHelper::reset_javascript_include_default
require 'jquery_for_rjs'
ActionController::Base.helper Handicraft::Helper