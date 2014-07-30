class OrganismRelatedDiseaseNanoStanza < TogoStanza::Stanza::Base
  property :list_disease do |tax_id|
    results = query("http://ep.dbcls.jp/sparql7ssd", <<-SPARQL.strip_heredoc)
      PREFIX pdo: <http://purl.jp/bio/11/pdo/>
      PREFIX tax: <http://identifiers.org/taxonomy/>
      SELECT DISTINCT ?pdo_id ?label
      FROM <http://togogenome.org/graph/pdo/>
      FROM <http://togogenome.org/graph/pdo_mapping/>
      WHERE {
        tax:#{tax_id} pdo:isAssociatedTo ?bk .
        ?bk ?p ?pdo_id .
        ?pdo_id rdfs:label ?l
        FILTER(regex(?pdo_id, "PDO"))
        BIND(str(?l) AS ?label)
      }
    SPARQL
    results[0] = "http://togostanza.org/static/pdo/pathogen.png" unless results == []
    results
  end
end
