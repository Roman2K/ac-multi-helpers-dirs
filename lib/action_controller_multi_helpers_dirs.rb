ActionController::Helpers.module_eval do
  not_applicable = lambda { raise "patch not applicable to the current version of ActionController" }
  
  # Prevent this constant from being used since its use would not yield the
  # behaviour expected to be brought by this patch.
  case
  when const_defined?("HELPERS_DIR")
    remove_const :HELPERS_DIR
  when (base = ActionController::Base).respond_to?("helpers_dir")
    [base.metaclass, base].each do |klass|
      klass.class_eval do
        remove_method :helpers_dir
        remove_method :helpers_dir=
        inheritable_attributes.delete(:helpers_dir) unless inheritable_attributes.frozen?
      end
    end
  else
    not_applicable[]
  end
  
  self::ClassMethods.module_eval do
    unless private_method_defined?('all_application_helpers')
      not_applicable[]
    end
    
  private
  
    def all_application_helpers
      directories = ActiveSupport::Dependencies.load_paths.grep(/\bhelpers$/)
      extract = /^(?:#{directories.map { |d| Regexp.escape d } * '|'})\/?(.*)_helper.rb$/
      Dir["{#{directories * ','}}/**/*_helper.rb"].map { |file| file.sub extract, '\1' }
    end
  end
end
