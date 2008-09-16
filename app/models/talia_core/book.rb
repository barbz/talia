module TaliaCore
  
  
  # This refers to a book in a collection. Note that each book is 
  # exactly in one Catalog/Macrocontribution (see AbstractWorkCard).
  class Book < ExpressionCard
    
    # NOT cloned: in_archive
    clone_properties N::DCNS.title,
      N::HYPER.position,
      N::DCNS.description,
      N::DCNS.date,
      N::DCNS.publisher,
      N::HYPER.publication_place,
      N::HYPER.copyright_note

    # The pages of this book
    def pages
      Page.find(:all, :find_through => [N::HYPER.part_of, self])
    end
    
    # The chapters of this book
    def chapters
      qry = Query.new(TaliaCore::Chapter).select(:c).distinct
      qry.where(:c, N::HYPER.book, self)
      qry.where(:c, N::HYPER.first_page, :p)
      qry.where(:p, N::HYPER.position, :pos)
      qry.sort(:pos)
      qry.execute  
    end
    
    # Creates an OrderedSource object for this` book containing all its pages, 
    # ordered by their position
    def order_pages!
      ordered = ordered_pages
      qry = Query.new(TaliaCore::Page).select(:p).distinct
      qry.where(:p, N::HYPER.part_of, self)
      qry.where(:p, N::HYPER.position, :pos)
      qry.sort(:pos)
      pages = qry.execute
      pages.each do |page| 
        ordered.add(page)
        ordered.save!
      end

    end
      
    # Returns an array containing all the pages in this book, ordered
    def ordered_pages
      uri = self.uri.to_s + '_ordered_pages'
      if OrderedSource.exists?(uri)
        OrderedSource.find(uri)
      else
        OrderedSource.new(uri)
      end
    end

    # returns the RDF.type of this book (e.g. Manuscript, Work, etc.)
    def type 
      qry = Query.new(TaliaCore::Source).select(:type).distinct
      qry.where(:self, N::RDF.type, :subtype)
      qry.where(:subtype, N::RDFS.subClassOf, :type)
      qry.where(:type, N::RDFS.subClassOf, N::HYPER.Material)
      qry.execute[0]
    end
  
    # returns the subClass of the RDF.type of this book (e.g. Copybook, Notebook, etc.) 
    def subtype 
      qry = Query.new(TaliaCore::Source).select(:subtype).distinct
      qry.where(:self, N::RDF.type, :subtype)
      qry.where(:subtype, N::RDFS.subClassOf, :type)
      qry.where(:type, N::RDFS.subClassOf, N::HYPER.Material)
      qry.execute[0]
    end
    
    # returns all the subpart of this expression card
    def subparts
      pages = pages_query.execute
      paragraphs = paragraphs_query.execute
      subparts = pages + paragraphs
    end
    
    # returns all the subpart of this expression card that have some manifestations 
    # of the given type related to them. Manifestation_type must be an URI
    def subparts_with_manifestations(manifestation_type, subpart_type = nil)
      assit_not_nil manifestation_type #TODO check that manifestation_type is an URI
      qry_pages = pages_query
      qry_pages.where(:m, N::HYPER.manifestation_of, :part)
      qry_pages.where(:m, N::RDF.type, manifestation_type) 
      qry_pages.where(:part, N::RDF.type, subpart_type) unless subpart_type.nil?
      pages = qry_pages.execute
      
      qry_para = paragraphs_query
      qry_para.where(:m, N::HYPER.manifestation_of, :part)
      qry_para.where(:m, N::RDF.type, manifestation_type) 
      qry_para.where(:part, N::RDF.type, subpart_type) unless subpart_type.nil?
      paragraphs = qry_para.execute
      
      subparts = pages + paragraphs
    end
    
    
    # Returns the PDF representation of this book
    def pdf
      # TODO: Implementation
    end
   
    private
  
    # default query for subparts 
    def pages_query
      qry = Query.new(TaliaCore::Source).select(:part).distinct
      qry.where(:part, N::HYPER.part_of, self)
      qry.where(:part, N::HYPER.position, :pos)
      qry.sort(:pos)
      qry
    end
    
    def paragraphs_query
      qry = Query.new(TaliaCore::Source).select(:part).distinct
      qry.where(:page, N::HYPER.part_of, self)
      qry.where(:page, N::RDF.type, N::HYPER.Page)
      
      if (self.catalog != TaliaCore::Catalog.default_catalog)  
        qry.where(:note, N::HYPER.page, :def_page)
        qry.where(:def_page, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
        qry.where(:page_concordance, N::HYPER.concordant_to, :def_page)
        qry.where(:page_concordance, N::HYPER.concordant_to, :page)
        qry.where(:def_para, N::HYPER.note, :note)
        qry.where(:para_concordance, N::HYPER.concordant_to, :def_para)
        qry.where(:para_concordance, N::HYPER.concordant_to, :part)
        qry.where(:part, N::HYPER.in_catalog, self.catalog)        
        qry.where(:def_page, N::HYPER.position, :page_pos)
        qry.where(:note, N::HYPER.position, :note_pos)
        qry.sort(:page_pos)
        qry.sort(:note_pos)
      else
        qry.where(:note, N::HYPER.page, :page)
        qry.where(:part, N::HYPER.note, :note)
        qry.where(:page, N::HYPER.position, :page_pos)
        qry.where(:note, N::HYPER.position, :note_pos)
        qry.sort(:page_pos)
        qry.sort(:note_pos)
          
      end
      qry
      
    end
  
  end
end