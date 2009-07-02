module TaliaCore
  
  class BookHtml < Manifestation
    # creates an HTML version of the whole book passed as argument. starting
    # from HyperEditions which are manifestation of subparts of the book
    def create_html_version_of(book, version=nil)
      book_text = ''
      book.subparts_with_manifestations(N::HYPER.HyperEdition).each do |part|
        each_related_facs_page(part) do |page|
          book_text << "<a href='#{page.uri}'>#{page.title}</a>"
        end
        part.manifestations(N::HYPER.HyperEdition).each do |manifestation|
          book_text << "<div class='txt_block' id='#{part.uri.to_s}_text'>"
          book_text << "<a name='manifestation_#{manifestation.uri.local_name}' />"
          #TODO: add the following too, to be calculated.
          # Needed when the full mode is ready
          # <p class="addons"><a href="#">1 facsimile </a>| <a href="#">2 commentaries</a> in <a href="#">Scholar Mode</a></p> 
          book_text << manifestation.to_html(version)
          book_text << "</div>"
        end
      end 
      book_text += ''
      if !self.data_records.empty? 
        data = self.data_records[0]
      else
        data = TaliaCore::DataTypes::XmlData.new
      end
      file_location = book.uri.local_name + ".html"
      data.create_from_data(file_location, book_text)
      if self.data_records.empty?
        self.data_records << data
        self.dcns::format << 'text/html'
      end
      self.save!
    end
    
    def each_related_facs_page(para)
      catalog = para.catalog
      result = ''
      conc_qry = Query.new(N::URI).select(:page, :cat).distinct
      conc_qry.where(:conc, N::HYPER.concordant_to, page)
      conc_qry.where(:conc, N::HYPER.concordant_to, :page)
      conc_qry.where(:page, N::HYPER.in_catalog, :cat)
      conc_qry.where(:fac, N::HYPER.manifestation_of, :page)
      conc_qry.where(:fac, N::RDF.type, N::HYPER.Facsimile)
      conc_qry.execute.each do |result_item|
        puts "XXXX: Move: #{result_item.to_s}"
        next if(Catalog::DEFAULT_CATALOG_NAME == result_item.last.to_s) || (result_item.first.to_s == catalog.to_s)
        r_page = Page.new(result_item.first.to_s)
        yield r_page
      end
    end
    
    def html
      self.data_records[0].content_string
    end
  end
end