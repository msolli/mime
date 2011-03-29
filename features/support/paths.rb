module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /forsiden/
      root_path
    when /ny artikkel-siden for "([^"]*)"$/
      new_article_path(headword: $1)
    when /ny artikkel-siden$/
      new_article_path
    when /artikkelvisning for "([^"]*)"$/
      pretty_article_path $1
    when /artikkelredigering for "([^"]*)"$/
      edit_article_path $1
    when /alfabetisk-siden for "([^"]*)"$/
      alphabetic_path $1
    when /versjonsloggen for "([^"]*)"$/
      article_versions_path $1
    when /innloggingssiden$/
      new_user_session_path
    when /brukerprofilen til "([^"]*)"$/
      user_path $1
    when /brukerprofilen min$/
      user_path("nn@example.com")
    when /artikkeloversikten min$/
      user_articles_path("nn@example.com")
    when /forsideredigering/
      edit_page_path(Page.first(conditions: { name: 'Forside'}))


    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
