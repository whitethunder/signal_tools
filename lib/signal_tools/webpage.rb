require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Webpage
  attr_accessor :page

  def initialize(url)
    @user_agent_hash = get_user_agent
    @page = get_webpage(url)
  end

  private

  def get_webpage(url)
    tries = 0
    begin
      Nokogiri::HTML(open(url, @user_agent_hash))
    rescue OpenURI::HTTPError
      tries += 1
      retry if tries < 3
      nil
    end
  end

  def get_user_agent
    user_agents = [
      'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)', # IE7
      'Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.4b) Gecko/20030516 Mozilla Firebird/0.6', # Win Mozilla
      'Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/418 (KHTML, like Gecko) Safari/417.9.3', # Mac Safari
      'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.0.3) Gecko/20060426 Firefox/1.5.0.3', # Mac Firefox
      'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030624' # Linux Mozilla
    ]
    {"User-Agent" => user_agents[rand * user_agents.size]}
  end
end
