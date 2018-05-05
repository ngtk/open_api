module OpenApi
  class Schema
    attr_accessor :nullable, :discriminator, :read_only, :write_only, :xml, :external_docs, :example, :deprecated

    def initialize(nullable: false, discriminator: nil, read_only: false, write_only: false, xml: nil, external_docs: nil, example: nil, deprecated: false, **other_fields_hash)
      self.nullable = nullable
      self.discriminator = discriminator
      self.read_only = read_only
      self.write_only = write_only
      self.xml = xml
      self.external_docs = external_docs
      self.example = example
      self.deprecated = deprecated
      self.other_fields_hash = other_fields_hash.with_indifferent_access

      other_fields_hash.keys.each do |key|
        define_singleton_method(key) do
          other_fields_hash[key]
        end
      end
    end

    def self.load(hash)
      other_fields_hash = hash.reject { |key|
        key.to_sym.in?([:nullable, :discriminator, :readOnly, :writeOnly, :xml, :externalDocs, :example, :deprecated])
      }.symbolize_keys

      new(
        nullable: hash["nullable"],
        discriminator: hash["discriminator"],
        read_only: hash["readOnly"],
        writeOnly: hash["writeOnly"],
        xml: Xml.load(hash["xml"]),
        external_docs: ExternalDocumentation.load(hash["externalDocs"]),
        example: Example.load(hash["example"]),
        deprecated: hash["deprecated"],
        **other_fields_hash,
      )
    end

    private

    attr_accessor :other_fields_hash
  end
end
