class TestRunner < Mumukit::FileTestRunner
  def run_test_command(file)
    "#{wollok_command} #{file} 2>&1"
  end

  def post_process_file(file, result, status)
    if result.include? 'WollokInterpreterException'
      [result, :failed]
    else
      super
    end
  end
end
