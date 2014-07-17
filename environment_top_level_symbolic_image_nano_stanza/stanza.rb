class EnvironmentTopLevelSymbolicImageNanoStanza < TogoStanza::Stanza::Base
  property :top_level_category do |meo_id|
    result = query("http://togostanza.org/sparql", <<-SPARQL.strip_heredoc).first
      PREFIX meo: <http://purl.jp/bio/11/meo/>
      SELECT DISTINCT ?ancestor
      FROM <http://togogenome.org/graph/meo/>
      WHERE {
        ?ancestor rdf:type owl:Class
        FILTER (?ancestor IN (meo:MEO_0000001, meo:MEO_0000002, meo:MEO_0000003, meo:MEO_0000004, meo:MEO_0000005) ).
        meo:#{meo_id} rdfs:subClassOf* ?ancestor .
      }
    SPARQL

    image_name = image_name_by_ancestor(result[:ancestor])
    result[:image_url] = "http://togogenome.org/images/#{image_name}.jpg"
    result
  end

  private

  def image_name_by_ancestor(ancestor)
    case ancestor
    when /MEO_0000001/
      'meo_atmosphere'
    when /MEO_0000002/
      'meo_terrestrial'
    when /MEO_0000003/
      'meo_human_activity'
    when /MEO_0000004/
      'meo_hydrosphere'
    when /MEO_0000005/
      'meo_organism_association'
    else
      'meo_not_found'
    end
  end
end
