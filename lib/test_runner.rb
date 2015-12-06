class TestRunner < Mumukit::FileTestRunner
  include Mumukit::WithIsolatedEnvironment

  def run_test_command(filename)
    "#{wollok_command} #{filename} 2>&1"
  end

  def post_process_file(file, result, status)
    if result.include? 'WollokInterpreterException'
      [result, :failed]
    else
      super
    end
  end
end
