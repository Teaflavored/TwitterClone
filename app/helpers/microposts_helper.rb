module MicropostsHelper
  
  def micropost_extract_username(params)
    message = params
    start=ending=nil
    if message.match(/\A@/)
      start=message.index(/@/)+1
      ending=message.index(/\W/,1)-1 if message.index(/\W/,1)!=nil
    end
    return nil if start.nil? || ending.nil?
    username = message[start..ending]
    return username
  end
  
  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  private
    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text :
                                   text.scan(regex).join(zero_width_space)
    end
end
