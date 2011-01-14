module VersionsHelper
  
  def version_number_or_text(version, count)
    case
    when count == 0
      t('articles.versions.active')
    when version.version == 1
      t('articles.versions.first')
    else
      t('articles.versions.print', :version => version.version)
    end
  end
  
end
