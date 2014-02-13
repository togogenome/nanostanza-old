class Protein3dStructureNanoStanza < TogoStanza::Stanza::Base
  property :pdb do |tax_id, gene_id|
    results = query("http://togostanza.org/sparql", <<-SPARQL.strip_heredoc)
      PREFIX core: <http://purl.uniprot.org/core/>

      SELECT ?up ?attr ?url
      FROM <http://togogenome.org/graph/uniprot/>
      FROM <http://togogenome.org/graph/tgup/>
      WHERE {
        <http://togogenome.org/gene/#{tax_id}:#{gene_id}> ?p ?id_upid .
        ?id_upid rdfs:seeAlso ?up .
        ?up a core:Protein .
        ?attr rdf:subject ?up .
        ?attr a core:Structure_Mapping_Statement .
        ?attr rdf:object ?url .
      }
    SPARQL
    results.map {|hash|
      hash.merge(
        img_url: "http://pdbj.org/pdb_images/#{hash[:url][-4, 4].downcase!}.jpg"
      )
    }
  end
end
