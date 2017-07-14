BASE_ENDPOINT = 'https://discordapp.com/api/'
CHANNEL = '332447582745919499'
# Hide this !
AUTHENTICATION_TOKEN = ''
USER_AGENT = 'User-Agent: DiscordBot'

# Auth

# I know shelling out is bad, but the rb http libs suck a dick.
def fire
  authentication_header = "--header \"Authorization: Bearer #{AUTHENTICATION_TOKEN}\""
  target_url = "#{BASE_ENDPOINT}/channels/#{CHANNEL}/messages"
  result = `curl #{authentication_header} #{target_url}`
  if $?.success?
      puts 'curl returns 0'
      puts result
  else
      puts 'curl returns non-0'
      puts result
  end
end

fire
