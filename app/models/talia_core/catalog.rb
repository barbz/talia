module TaliaCore
  
  # A catalog is a collection of AbstractWorkCard records. 
  class Catalog < Source
    
    DEFAULT_CATALOG_NAME = N::LOCAL + 'system_default_catalog'
    
    # Returns all the elements, restricting the result to the given type
    # if one is given. The type should be a class.
    def elements(type = nil)
      type ||= Source
      raise(ArgumentError, "Type for elements should be a class") unless(type.is_a?(Class))
      type.find(:all, :find_through => [N::HYPER.in_catalog, self])
    end
    
    
     # Returns an array containing a list of all the elements of the given type 
    # (manuscripts, works, etc.). Types can also contain subtypes (notebook, draft, etc.) 
    # 
    # The types should be a list of N::URI elements indicating the RDF classes.
    def elements_by_type(*types)
      qry = Query.new(TaliaCore::ActiveSource).select(:element).distinct
      types.each do |type|
        qry.where(:element, N::RDF.type, type)
      end
      qry.where(:element, N::HYPER.in_catalog, self)
      qry.execute
    end
    
    # Creates a new concordant record for the given element and adds it 
    # to the catalog. This will also copy the properties of the given 
    # element.
    #
    # If no siglum is given, this will use the same siglum as the element given.
    # 
    # The URI of the new element will be <catalog_uri>/<siglum>
    def add_from_concordant(concordant_element, children = false, new_siglum = nil)
      raise(ArgumentError, "Can only create concordant catalog elements from Cards, this was a #{concordant_element.class}: #{concordant_element.uri}") unless(concordant_element.is_a?(ExpressionCard))
      siglum = new_siglum || concordant_element.siglum || concordant_element.uri.local_name
      new_el = concordant_element.clone_concordant(self.uri + '/' + siglum, true, self) # it will convert relation objects to use source part of the present catalog
      new_el.catalog = self
      new_el.save!
      if(children)
        for_children_of(concordant_element) do |child|
          new_clone = add_from_concordant(child, true)
          new_clone.hyper::part_of << new_el
          new_clone.save!
        end
      end
      
      
      assit_equal(new_el.concordance[N::HYPER.concordant_to].size, new_el.concordance.my_rdf[N::HYPER.concordant_to].size)
      new_el
    end
    
    # This adds the element to this catalog. This disassociates the elements
    # from their previous catalog and does not modify their URIs.
    def add_card(element, children = false)
      raise(ArgumentError, "Can only add ExpressionCards") unless(element.is_a?(ExpressionCard))
      element.catalog = self
      
      if(children)
        for_children_of(element) { |child| add_card(child, true) }
      end
    end
    
    def title
      @title ||= self.hyper::title.last
    end
    
    def description
      @description ||= self.hyper::description.last
    end
    
    # Returns the default catalog that will be used if no other catalog is
    # specified
    def self.default_catalog
      catalog = Catalog.new(Catalog::DEFAULT_CATALOG_NAME)
      catalog.save! if(catalog.new_record?)
      catalog
    end
    
    # A descriptive text about this element
    def material_description
      description = inverse[N::HYPER.description_of]
      assit(description.size <= 1, "There shouldn't be multiple descriptions")
      (description.size > 0) ? description[0] : ''
    end
    
    protected
    
    
    # Goes through the children of the given element
    def for_children_of(element)
      children = Source.find(:all, :find_through => [N::HYPER.part_of, element]).uniq
      children.each { |child| yield(child) }
    end
    
  end
  
end