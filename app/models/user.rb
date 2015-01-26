require 'redbooth-ruby'

class User < ActiveRecord::Base
  def create_task text, project_name
    redbooth_session = RedboothRuby::Session.new(
      token: self.token
    )
    client = RedboothRuby::Client.new(redbooth_session)

    projects = JSON.parse client.project(:index).response.body
    project_id = nil

    projects.each do |red_project|
      if red_project['name'] == project_name
        project_id = red_project['id']
      end
    end

    if project_id.nil?
      orgs = JSON.parse client.organization(:index).response.body
      # TODO: needs handle when user has more than one organization
      project = client.project( :create, name: project_name,
                                organization_id: orgs[0]['id'])
    else
      project = client.project(:show, id: project_id)
    end

    task_lists = client.task_list(:index, project_id: project.id)
    lists = JSON.parse task_lists.response.body

    task = client.task(:create, name: text, project_id: project.id,
                                task_list_id: lists[0]['id'])
  end

  def get_token
    client_id = ENV['REDBOOTH_APP_ID']
    client_secret = ENV['REDBOOTH_APP_SECRET']
    oauth2_urls = {
      site: 'https://redbooth.com/api/3',
      token_url: 'https://redbooth.com/oauth2/token',
      authorize_url: 'https://redbooth.com/oauth2/authorize'
    }

    @oauth2_client = OAuth2::Client.new(client_id, client_secret, oauth2_urls)
    @access_token = OAuth2::AccessToken.new(@oauth2_client, self.token)
    refresh_access_token_obj = OAuth2::AccessToken.new(@oauth2_client, @access_token.token, {'refresh_token' => self.refresh_token})
    @access_token = refresh_access_token_obj.refresh!
    new_token = @access_token.token
    self.update token: new_token
  end
end
