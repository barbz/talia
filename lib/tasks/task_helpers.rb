class TaskHelper
  
  # Returns a preset RDF query that will select all books that have pages
  # in the default catalog. The books are referred to by :book and the
  # pages by :page. 
  # You may add additional conditions to this query before executing
  def self.default_book_query
    qry = Query.new(TaliaCore::Book).select(:book).distinct
    qry.where(:book, N::RDF.type, N::HYPER.Book)
    # only select from the default catalog
    qry.where(:book, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
    qry.where(:page, N::HYPER.part_of, :book)
    qry
  end
  
  # Creates a new edition, using the given edition
  # class. This will use the environment variables passed to the rake task
  def self.create_edition(ed_klass)
    raise(ArgumentError, "Edition must be a Catalog type") unless(ed_klass.new.is_a?(TaliaCore::Catalog))
    ed_uri = N::LOCAL +  ed_klass::EDITION_PREFIX + '/' + ENV['nick']
    raise(RuntimeError, "Edition does already exist: #{ed_uri}") if(TaliaCore::ActiveSource.exists?(ed_uri))
    edition = ed_klass.new(ed_uri)
    edition.hyper::title << ENV['name']
    edition.hyper::description << ENV['description']
    edition.save!
    edition
  end
  
  # Loops through the given books (with a progress meter).
  def self.process_books(books, progress_size = nil)
    progress_size ||= books.size
    puts "Processing #{books.size} books (#{progress_size} elements to process)..."
    progress = ProgressBar.new('Books', progress_size)
    books.each do |book|
      yield(book,progress)
    end
    progress.finish
  end
  
  # Loads the constants/classes for the models
  def self.load_consts
    # Require some model classes that should always be present
    %w( source expression_card catalog facsimile_edition critical_edition manifestation book page paragraph facsimile).each do |klass|
      require_dependency "talia_core/#{klass}"
    end
  end
  
end
