require_relative '../../test_helper'

module SamlTool
  class ReaderTest < Minitest::Test

    def test_reader
      config = Settings.new(
        foo: xpath_to_return_foo_text
      )
      @reader = Reader.new(nested_saml, config)
      assert_equal 'bar', @reader.foo
    end

    def test_reader_with_string_hash_config
      reader = Reader.new(
                 nested_saml,
                 'foo' => xpath_to_return_foo_text
               )
      assert_equal 'bar', reader.foo
    end

    def test_reader_can_get_attribute
      reader = Reader.new(
                 nested_saml,
                 'foo' => xpath_to_return_foo_attribute
               )
      assert_equal 'that', reader.foo
    end
    
    def test_reader_with_name_space
      reader =  Reader.new(
                  response_xml,
                  {foo: '//ds:X509Certificate/text()'},
                  {ds: 'http://www.w3.org/2000/09/xmldsig#'}
                )
      assert_equal 'MIIBrT', reader.foo[0...6]
    end
    
    def test_value_remembers_source
      saml = SamlTool::SAML(nested_saml)
      source = saml.xpath(xpath_to_return_foo_text)
      test_reader
      assert_equal source.class, @reader.foo.source.class
      assert_equal source.to_s, @reader.foo.source.to_s
      assert_equal @reader.foo, @reader.foo.source.to_s
    end
    
    def test_to_hash
      reader = Reader.new(
        nested_saml,
        {
          foo: xpath_to_return_foo_text,
          this: xpath_to_return_foo_attribute
        }
      )
      expected = {
        foo: 'bar',
        this: 'that'
      }
      assert_equal expected, reader.to_hash
    end
    
    class FooReader < Reader
      def initialize(saml)
        super(
          saml,
          {
            foo: 'level_one/foo[1]/text()',
            this: 'level_one/foo[1]/@this'
          }
        )
      end
    end

    def test_reader_via_inherited_class
      reader = FooReader.new(nested_saml)
      assert_equal 'bar', reader.foo
      assert_equal 'that', reader.this
    end

    def nested_saml
      '<level_one><foo this="that">bar</foo></level_one>'
    end
    
    def xpath_to_return_foo_text
      'level_one/foo[1]/text()'
    end
    
    def xpath_to_return_foo_attribute
      'level_one/foo[1]/@this'
    end

  end
end
