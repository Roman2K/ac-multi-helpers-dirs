require 'test/unit'
require 'mocha'

require 'action_controller'
require 'action_controller_multi_helpers_dirs'

class ActionControllerMultiHelpersDirsTest < Test::Unit::TestCase
  def setup
    @controller = Object.new.extend ActionController::Helpers::ClassMethods
  end
  
  def test_helpers_dir
    assert !ActionController::Helpers.const_defined?(:HELPERS_DIR)
    assert !ActionController::Base.respond_to?(:helpers_dir)
    assert !ActionController::Base.respond_to?(:helpers_dir=)
    assert !ActionController::Base.method_defined?(:helpers_dir)
    assert !ActionController::Base.method_defined?(:helpers_dir=)
    assert !ActionController::Base.inheritable_attributes.keys.include?(:helpers_dir)
  end
  
  def test_all_application_helpers
    ActiveSupport::Dependencies.stubs(:load_paths).returns %w(foo/helpers baz/models bar/helpers)
    Dir.stubs(:[]).with('{foo/helpers,bar/helpers}/**/*_helper.rb').returns %w(foo/helpers/abc_helper.rb foo/helpers/nest/def_helper.rb bar/helpers/ghi_helper.rb)
    
    assert_equal %w(abc nest/def ghi), @controller.instance_eval { all_application_helpers }
  end
  
  def test_test_all_application_helpers_with_no_helper_dir
    ActiveSupport::Dependencies.stubs(:load_paths).returns []
    Dir.expects(:[]).never
    
    assert_equal [], @controller.instance_eval { all_application_helpers }
  end
end
