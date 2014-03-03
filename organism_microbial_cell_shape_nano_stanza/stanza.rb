class OrganismMicrobialCellShapeNanoStanza < TogoStanza::Stanza::Base
  property :cell_shapes do |tax_id|
    results = query("http://togostanza.org/sparql", <<-SPARQL.strip_heredoc)
      PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
      PREFIX mpo: <http://purl.jp/bio/01/mpo#>
      PREFIX tax: <http://identifiers.org/taxonomy/>
      SELECT DISTINCT ?cell_shape ?label
      FROM <http://togogenome.org/graph/mpo/>
      FROM <http://togogenome.org/graph/gold/>
      WHERE {
        tax:#{tax_id} mpo:MPO_10001 ?cell_shape .
        ?cell_shape rdfs:label ?l .
        FILTER (lang(?l) = "en")
        BIND(str(?l) AS ?label)
      }
    SPARQL
    image = "http://togostanza.org/static/img/cell_shapes/"
    url = image + results[0][:label].downcase + ".png"
    results[0][:image_url] = url
    results
  end
end
