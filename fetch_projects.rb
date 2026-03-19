require 'net/http'
require 'json'
require 'yaml'
require 'base64'

PROJECTS_FILE = '_data/projects.yml'

def fetch_readme(username, repo)
  uri = URI("https://api.github.com/repos/#{username}/#{repo}/contents/README.md")
  req = Net::HTTP::Get.new(uri)
  req['Accept'] = 'application/vnd.github.v3+json'

  response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
    http.request(req)
  end

  return nil unless response.code == '200'

  content = JSON.parse(response.body)['content']
  Base64.decode64(content.tr("\n", ''))
rescue => e
  puts "    Error: #{e.message}"
  nil
end

config = YAML.safe_load(File.read('_config.yml'))
username = config['github_username'] || 'srwarrier'

file_data = YAML.safe_load(File.read(PROJECTS_FILE))
repos = file_data['repos'] || []

puts "Fetching #{repos.length} READMEs for #{username}..."

projects = repos.map do |repo|
  repo = repo.to_s.strip
  puts "  #{repo}..."
  readme = fetch_readme(username, repo)
  
  { 'repo' => repo, 'readme' => readme }
end

File.write(PROJECTS_FILE, { 'repos' => repos, 'projects' => projects }.to_yaml(line_width: -1))
puts "Done."
