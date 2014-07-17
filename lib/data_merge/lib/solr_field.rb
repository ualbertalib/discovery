require "nokogiri"
require_relative "./xml_field.rb"

class SolrField

  def initialize(xml_field)
    @xml_field = XmlField.new({content:xml_field})
    @field = converted_field
  end

  def to_s
    @field
  end

  private

  def converted_field
    if @xml_field.has_attribute?
      qualified_field
    elsif @xml_field.nested?
      nested_field
    else
      simple_field
    end
  end

  def simple_field
    %Q(<field name="#{@xml_field.name}">#{@xml_field.text.strip}</field>)
  end

  def qualified_field
    %Q(<field name="#{@xml_field.qualifier}_#{@xml_field.name}">#{@xml_field.text.strip}</field>)
  end

  def nested_field
    if @xml_field.depth == 2
      %Q(<field name="#{@xml_field.parent}">#{@xml_field.text.strip}</field>)
    else
      fs = FieldSet.new
      fs.add @xml_field.children.first.children.to_s
      fs.each_as_string
    end
  end
end
