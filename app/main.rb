require 'jira-ruby'

JiraProject = Struct.new("JiraProject", :id, :name, :issues)
JiraIssue = Struct.new("JiraIssue", :id, :summary, :issuetype)

# Создать подключение к Jira
def jira_client() 
    options = {
        site: ENV['JIRA_BASE_URL'],
        context_path: "",
        auth_type: :basic,
        username: ENV["JIRA_USER_EMAIL"],
        password: ENV["JIRA_API_TOKEN"]
    }
    JIRA::Client.new(options)
end

version=ENV['INPUT_VERSION']
projects=ENV['INPUT_PROJECTS'].split(",").map{ |p| p.strip }
result = []

begin
    client = jira_client()
    # Получить список задач с искомой fixVersion во всех проектах
    projects.each do |project_id|
        project = client.Project.find(project_id)
        jql = "PROJECT = '#{project_id}' AND fixVersion = '#{version}'"
        issues = client.Issue.jql(jql, max_results: 100)
                             .map { |i| JiraIssue.new(i.key, i.summary, i.issuetype.name) }
        next if issues.empty?
        result.append(JiraProject.new(project_id, project.name, issues))
    end
rescue JIRA::HTTPError => e
    fields = [e.code, e.message]
    fields << e.response.body if e.response.content_type == "application/json"
    puts "#{e} #{fields.join(', ')}"
    exit(-1)
end

# Сформировать Release Notes
notes = result.map do |project| 
    list = project.issues.map { |i| "[#{i.id}] - #{i.summary}" }.join("\n")
    "#{project.name}\n\n#{list}\n"
end

puts "::set-output name=release_notes::#{notes.join("\n")}"