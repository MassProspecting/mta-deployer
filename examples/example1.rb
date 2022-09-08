# This example shows how to send an API call to NameCheap.
# For more information about setting up your API keys, see: https://www.namecheap.com/support/api/intro/

require 'net/http'
require 'nokogiri'

namecheap_api_key='******'
namecheap_user='LeandroSardi'
namecheap_username='LeandroSardi'
namecheap_client_ip='200.114.237.5'
url = "https://api.namecheap.com/xml.response?ApiUser=#{namecheap_user}&ApiKey=#{namecheap_api_key}&UserName=#{namecheap_username}&ClientIp=#{namecheap_client_ip}&Command=namecheap.domains.check&DomainList=sdfsf345435sdfsdf.site"

uri = URI(url)
res = Net::HTTP.get(uri)

xml = Nokogiri::XML(res)
available = xml.at('DomainCheckResult').attr('Available')
puts "Available: #{available.to_s}"
