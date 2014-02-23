class EnvironmentOrganismDistributionOnPhNanoStanza < TogoStanza::Stanza::Base
  property :list do |meo_id|
    results = query("http://togostanza.org/sparql", <<-SPARQL.strip_heredoc)
      PREFIX mpo: <http://purl.jp/bio/01/mpo#>
      PREFIX mccv: <http://purl.jp/bio/01/mccv#>
      PREFIX meo: <http://purl.jp/bio/11/meo/>
      SELECT ?tax_id ?opt_ph ?min_ph ?max_ph
      FROM <http://togogenome.org/graph/gold/>
      FROM <http://togogenome.org/graph/mpo/>
      FROM <http://togogenome.org/graph/meo/>
      FROM <http://togogenome.org/graph/mccv/>
      WHERE {
        VALUES ?meo_mapping { meo:MEO_0000437 meo:MEO_0000440 } .
        ?descendant rdfs:subClassOf* meo:#{meo_id} .
        ?gold ?meo_mapping ?descendant .
        ?gold mccv:MCCV_000020 ?tax_id .
        OPTIONAL {?tax_id mpo:MPO_10005 ?opt_ph}
        OPTIONAL {?tax_id mpo:MPO_10006 ?min_ph}
        OPTIONAL {?tax_id mpo:MPO_10007 ?max_ph}
        BIND (COALESCE(?opt_ph, ?min_ph, ?max_ph, <NopH>) AS ?ph)
        FILTER (regex(?tax_id, "identifiers.org") && !(?ph = <NopH>))
      }
    SPARQL
    keys = [:a, :b, :c, :d, :e, :f, :g]
    mapping = {0=>:a, 1=>:b, 2=>:c, 3=>:d, 4=>:e, 5=>:f, 6=>:g}
    vals = Array.new(7) {0}
    ph2orgs = Hash[keys.zip(vals)]
    results.each do |rslt|
      if rslt.key?(:opt_ph)
        ph2orgs[mapping[(rslt[:opt_ph].to_f / 2).floor]] += 1
      else rslt.key?(:min_ph) && rslt.key?(:max_ph)
        ph2orgs[mapping[((rslt[:min_ph].to_f + rslt[:max_ph].to_f)/ 4).floor]] += 1
      end
    end
    ph2orgs
  end
end
