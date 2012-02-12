# ac-multi-helpers-dirs

In Rails applications, helper modules are usually all located somewhere under `app/helpers/`. This is what is expected when eager loading helpers with `helper :all`. Unfortunately, it is not possible to indicate Rails other directories to find helper files in. This plugin introduces a way to circumvent this limitation.

## How it works

With this plugin, `helper :all` will look for `*_helper.rb` files in every `helpers` directory whose path is present in the `ActiveSupport::Dependencies.load_paths` array.

## Usage

Install the plugin:

    script/plugin install git://github.com/Roman2K/ac-multi-helpers-dirs.git 

Example configuration in `environment.rb`:

    config.load_paths += Dir["#{Rails.root}/app/*/helpers"]

This allows for having code organized like:

    app/
      controllers/
        application_controller.rb
      accounting/
        models/
        views/
        controllers/
        helpers/
      system/
        models/
        views/
        controllers/
        helpers/
      ...

and have `ApplicationController` call the usual `helper :all` to eager load helpers located under both `accounting/helpers/` and `system/helpers/`.
