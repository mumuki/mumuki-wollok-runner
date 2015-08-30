class TestRunner < Mumukit::FileTestRunner
  def run_test_command(file)
    "#{wollok_command} #{file}"
  end
end
