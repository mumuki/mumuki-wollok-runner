require 'rest-client'

class WollokQueryHook < Mumukit::Hook
  def run!(request)
    result = RestClient.post('ec2-52-38-24-64.us-west-2.compute.amazonaws.com:8080/run', request)
    if  result['runtimeErrors'].present?
      [result['runtimeErrors'], :failed]
    else
      [result['console'], :passed]
    end
  end

  def compile(r)
<<WLK
#{r.extra}
#{r.content}
program mumuki {
  #{build_state(r.cookie)}
  console.println('=> ' + (#{r.query}).toString())
}
WLK
  end

  def build_state(cookie)
    (cookie||[]).map { |statement| "try { #{statement} } catch e : Exception {  }" }.join("\n")
  end
end