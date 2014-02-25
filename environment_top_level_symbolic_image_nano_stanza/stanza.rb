class EnvironmentTopLevelSymbolicImageNanoStanza < TogoStanza::Stanza::Base
  property :top_level_category do |meo_id|
    result = query("http://togostanza.org/sparql", <<-SPARQL.strip_heredoc)
      PREFIX meo: <http://purl.jp/bio/11/meo/>
      SELECT DISTINCT ?ancestor
      FROM <http://togogenome.org/graph/meo/>
      WHERE {
        VALUES ?ancestor { meo:MEO_0000001 meo:MEO_0000002 meo:MEO_0000003 meo:MEO_0000004 meo:MEO_0000005 }
        meo:#{meo_id} rdfs:subClassOf* ?ancestor .
      }
    SPARQL

    tg_img = "http://togogenome.org/images"
    case result[0][:ancestor]
    when /MEO_0000001/
      result[0][:image_url] = "#{tg_img}/meo_atmosphere.jpg"
    when /MEO_0000002/
      result[0][:image_url] = "#{tg_img}/meo_terrestrial.jpg"
    when /MEO_0000003/
      result[0][:image_url] = "#{tg_img}/meo_human_activity.jpg"
    when /MEO_0000004/
      result[0][:image_url] = "#{tg_img}/meo_hydrosphere.jpg"
    when /MEO_0000005/
      result[0][:image_url] = "#{tg_img}/meo_organism_association.jpg"
    else
      result[0][:image_url] = "#{tg_img}/meo_not_found.jpg"
    end
    result
  end
end
