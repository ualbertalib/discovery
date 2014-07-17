class XmlField

  def initialize(params = {})
    @content = Nokogiri::XML(params[:content])
    compute_nesting
  end

  def to_s
    @content
  end

  def has_attribute?
    @content.children.first.keys.size > 0
  end

  def name
    @content.children.first.name
  end

  def text
    @content.text
  end

  def qualifier
    @content.children.first.values.first
  end

  def nested?
    @text_path.size > 1  # text_path is node names minus "document" and "text"
  end

  def parent
     @text_path.join("_")
  end

  def children
    @content.children
  end

  def depth
    nest_level
  end

  private

  def compute_nesting
    @text_path = []
    @content.traverse{|child| @text_path << child.name}
    @text_path.delete("document")
    @text_path.delete("text")
  end

  def nest_level
    @text_path.size
  end
end

