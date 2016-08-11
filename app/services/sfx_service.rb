require_relative "./marc_module.rb"

class SFXService
  include MarcModule

  module Error
    class HTTPError < StandardError; end
  end
  EXCEPTIONS = [Timeout::Error,
    Errno::EINVAL,
    EOFError,
    OpenURI::HTTPError,
    Net::HTTPBadResponse,
    Net::HTTPHeaderSyntaxError,
    Net::ProtocolError]

  attr_reader :targets

  def initialize(document)
    @targets = {}
    raw_targets(nokogiri document).each do |target|
      coverage = get_marc_subfield(target, 'a')
      @targets[sfx_id(target)] = {id: sfx_id(target), coverage: coverage}
    end

    sfx_results_for(document.id).xpath("//target").each do |target|
      unless local_targets.include? name(target)
        if @targets[id(target)]
          @targets[id(target)].merge!({name: display_name(target), url: url(target), our_target: our_link(target), note: note(target)}) 
        else
          @targets[id(target)] = {name: display_name(target), url: url(target), our_target: our_link(target), note: note(target), coverage: "Coverage information temporarily unavailable."}
        end
      end
    end
    @targets.delete_if{|key, value| value[:name].nil? }
  end

  private

  def sfx_results_for(id)
    begin
      Nokogiri::XML(open("http://resolver.library.ualberta.ca/resolver?ctx_enc=info%3Aofi%2Fenc%3AUTF-8&ctx_ver=Z39.88-2004&rfr_id=info%3Asid%2Fualberta.ca%3Aopac&rft.genre=journal&rft.object_id=#{id}&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&url_ctx_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Actx&url_ver=Z39.88-2004&sfx.response_type=simplexml").read)
    rescue *EXCEPTIONS => e
      raise Error::HTTPError, 'SFXService: ' + e.message
      nil
    end
  end

  def raw_targets(doc)
    marc_field(doc, '866')
  end

  def sfx_id(target)
    BigDecimal.new(get_marc_subfield(target, 's')).to_i
  end

  def local_targets
    ["LOCAL_CATALOGUE_SIRSI_UNICORN", "MESSAGE_NO_DOCDEL_LCL"]
  end

  def name(target)
   target.xpath("target_name").text
  end

  def display_name(target)
   target.xpath("target_public_name").text
  end

  def url(target) 
    target.xpath("target_url").text
  end

  def note(target)
    target.xpath("note").text
  end

  def id(target)
    BigDecimal.new(target.xpath("target_service_id").text).to_i
  end

  def our_link(target)
    target.xpath("authentication").text.gsub("http", "https") if target.xpath("authentication").text.include? "tal.scholarsportal.info"
  end

end
