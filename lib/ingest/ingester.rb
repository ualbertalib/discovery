require "rsolr"

class Ingester
  attr_writer :solr_object

  def add_document(vocabulary)
    add vocabulary
  end

  def commit
    @solr_object.commit
  end

private

  def add(vocabulary)
    @solr_object.add vocabulary
  end

end
