# frozen_string_literal: true

module OauthBwergemn
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../../templates', __FILE__)

    def copy_initializer
      template 'initializer.rb', 'config/initializers/oauth_bwergemn.rb'
    end
  end
end
