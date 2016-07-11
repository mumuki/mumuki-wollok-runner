class WollokTestHook < Mumukit::Hook
  def run!(request)
    result = RestClient.post('ec2-52-38-24-64.us-west-2.compute.amazonaws.com:8080/run', request)
    if  result['runtimeErrors'].present?
      [result['runtimeErrors'], :failed]
    else
      [result['console'] || '', :passed]
    end
  end

  def compile(r)
<<WLK
#{r.extra}
#{r.content}
#{r.test}
WLK
  end

end