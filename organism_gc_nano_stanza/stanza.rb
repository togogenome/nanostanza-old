require 'open-uri'

class OrganismGcNanoStanza < TogoStanza::Stanza::Base
  property :title do
    "GC%"
  end

  property :gc do |tax_id|
    # http://localhost:9292/stanza/organism_gc_nano?tax_id=192222

    results = query('http://ep.dbcls.jp/sparql-bh1313', <<-SPARQL.strip_heredoc)
      PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
      PREFIX tax: <http://identifiers.org/taxonomy/>
      PREFIX insdc: <http://ddbj.nig.ac.jp/ontologies/sequence#>

      SELECT ?refseq
      WHERE {
        GRAPH <http://togogenome.org/graph/refseq/> {
          ?seq rdfs:seeAlso tax:#{tax_id} .
          ?seq insdc:sequence_version ?refseq .
#         ?seq rdfs:seeAlso ?refseq_uri .
#         ?refseq_uri a <http://identifiers.org/refseq/> .
        }
      }
    SPARQL
    count = Hash.new(0)
    results.each do |res|
      # {:refseq=>"NC_002163.1"}
      seq = open("http://togows.org/entry/nucleotide/#{res[:refseq]}/seq").read
      at = seq.count("a") + seq.count("t")
      gc = seq.count("g") + seq.count("c")
      count["at"] += at
      count["gc"] += gc
    end
    gc_percent = 100 * count["gc"] / (count["gc"] + count["at"])
  end
end
