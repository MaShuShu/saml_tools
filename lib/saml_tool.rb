# Namespace definition

require 'nokogiri'
require 'hashie'
require 'securerandom'
require 'base64'
require 'zlib'
require 'openssl'
require 'xmldsig'

module SamlTool
  require_relative 'saml_tool/validator'
  require_relative 'saml_tool/erb_builder'
  require_relative 'saml_tool/encoder'
  require_relative 'saml_tool/decoder'
  require_relative 'saml_tool/redirect'
  require_relative 'saml_tool/settings'
  require_relative 'saml_tool/reader'
  require_relative 'saml_tool/response_reader'
  require_relative 'saml_tool/saml'
  require_relative 'saml_tool/certificate'
  require_relative 'saml_tool/rsa_key'
end
