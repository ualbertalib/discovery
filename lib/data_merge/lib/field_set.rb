require "nokogiri"
require_relative "./solr_field.rb"
require_relative "./xml_field.rb"

class FieldSet
  def initialize(root_element="")
    @field_set = []
    @root_element = root_element
  end

  def add(xml_data)
    nodes = nokogiri_document_from xml_data
    nodes.each do |field|
      @field_set << solr(field) unless field.is_a? Nokogiri::XML::Text
    end
  end

  def size
    @field_set.size
  end

  def first
    @field_set.first
  end

  def to_s
    @field_set.to_s
  end

  def [](index)
    @field_set[index]
  end

  def each_as_string
    return_string = ""
    @field_set.each do |field|
      return_string += field.to_s
    end
    return_string
  end

  def to_solr
    solr_record = %Q(<?xml version="1.0" encoding="UTF-8"?><add><doc>)
    @field_set.each do |field|
      solr_record += %Q(#{field.to_s})
    end
    solr_record += %Q(</doc></add>)
  end

  private

  def nokogiri_document_from(xml_data)
    if @root_element.empty?
      Nokogiri::XML("<doc>"+xml_data+"</doc>").xpath("//doc").children
    else
      Nokogiri::XML(xml_data).xpath(@root_element).children
    end
  end

  def solr(field)
    SolrField.new(field.to_s)
  end
end
