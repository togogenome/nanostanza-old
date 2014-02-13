class OrganismGeneNumberNanoStanza < TogoStanza::Stanza::Base
  property :genome_stats do |tax_id|
   result = query('http://togostanza.org/sparql', <<-SPARQL.strip_heredoc)
     PREFIX tgstat:<http://togogenome.org/stats/>
     PREFIX taxid:<http://identifiers.org/taxonomy/>

     SELECT DISTINCT ?project_num ?gene_num ?rrna_num ?trna_num
     FROM <http://togogenome.org/graph/stats/>
     WHERE
     {
       taxid:#{tax_id} tgstat:bioproject ?project_num ;
       tgstat:gene ?gene_num ;
       tgstat:rrna ?rrna_num ;
       tgstat:trna ?trna_num .
     }
   SPARQL

   if result == nil || result.size == 0 then
     next
   end

   gene_number = (result.first[:gene_num].to_f / result.first[:project_num].to_f).round
   rrna_number = (result.first[:rrna_num].to_f / result.first[:project_num].to_f).round
   trna_number = (result.first[:trna_num].to_f / result.first[:project_num].to_f).round
   ret = { :gene_number => gene_number, :rrna_number => rrna_number, :trna_number => trna_number }
   ret

  end
end
