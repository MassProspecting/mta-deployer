# Nothing to write here.
# This file exists only because it is requested by MySaaS when the extension is appended.

# require all needed gems here.
require "blackstack-nodes"
require 'blackstack-deployer'
require 'simple_cloud_logging'
require 'net/http'
require 'nokogiri'

# define a module to setup any configuration for your extension.
module BlackStack
    module MtaDeployer
        @@nodes = []
        # NameCheap API parameters
        @@namecheap_api_key = nil
        @@namecheap_user = nil
        @@namecheap_username = nil
        @@namecheap_client_ip = nil
        
        # inherit BlackStack::Deployer::NodeModule, including features of deployer.
        module NodeModule
            attr_accessor :domain, :addresses
    
            include BlackStack::Deployer::NodeModule
        
            def self.descriptor_errors(h)
                # default deployment reoutine - required by BlackStack::Deployer::NodeModule
                h[:deployment_routine] = 'mta-deployer-deploy' if h[:deployment_routine].nil?
                # validations by BlackStack::Deployer::NodeModule
                errors = BlackStack::Deployer::NodeModule.descriptor_errors(h)        
                # validate: h must have :domain attribute and it must be a string
                errors << "The parameter h does not have a key :domain" unless h.has_key?(:domain)
                errors << "The parameter h[:domain] is not a string" unless h[:domain].is_a?(String)
                # validate: :domain is a valid domain name: sld.tld
                errors << "The parameter h[:domain] is not a valid domain name" unless h[:domain].to_s.match(/^[a-z0-9\-\.]+\.[a-z]{2,8}$/i)
                # validate: h must have :addresses attribute and it must be an array of strings
                errors << "The parameter h does not have a key :addresses" unless h.has_key?(:addresses)
                errors << "The parameter h[:addresses] is not an array" unless h[:addresses].is_a?(Array)
                h[:addresses].each do |address|
                    errors << "The parameter h[:addresses] contains a non-string element" unless address.is_a?(String)
                end
                # return list of errors
                errors.uniq
            end
    
            def initialize(h, i_logger=nil)
                # mappping attributes
                self.parameters = h
                errors = BlackStack::MtaDeployer::NodeModule.descriptor_errors(h)
                raise "The node descriptor is not valid: #{errors.uniq.join(".\n")}" if errors.length > 0
                super(h, i_logger)
                self.domain = h[:domain]
                self.addresses = h[:addresses]
                self.deployment_routine = h[:deployment_routine]
            end # def self.create(h)
        
            def to_hash
                h = super
                h[:domain] = self.domain
                h[:addresses] = self.addresses
                h
            end # def to_hash
            
            # setup MX, SPF, DKIM and DMARC records for the domain
            def setup_dns(host_name, record_type, address, ttl=3600)
                sld = self.domain.split('.').first
                tld = self.domain.split('.').last
                url = "https://api.namecheap.com/xml.response?apiuser=#{namecheap_user}&apikey=#{namecheap_api_key}&username=#{namecheap_username}&Command=namecheap.domains.dns.setHosts&ClientIp=#{namecheap_client_ip}&SLD=#{sld}&TLD=#{tld}&HostName1=#{host_name}&RecordType1=#{record_type}&Address1=#{address}&TTL1=#{ttl}"
            end

        end # module NodeModule
    
        # TODO: declare these classes (stub and skeleton) using blackstack-rpc
        #
        # Stub Classes
        # These classes represents a node, without using connection to the database.
        # Use this class at the client side.
        class Node
            include BlackStack::MtaDeployer::NodeModule
        end # class Node

        # validate the configuration descriptor
        def self.descriptor_errors(h)
            errors = []
            # validate: the parameter h is a hash
            errors << "The parameter h is not a hash" unless h.is_a?(Hash)
            # if h is a hash
            if h.is_a?(Hash)
                # validate: the parameter h has a key :namecheap_api_key and it is a string
                errors << "The parameter h does not have a key :namecheap_api_key or it is not a string" unless h.has_key?(:namecheap_api_key) && h[:namecheap_api_key].is_a?(String)
                # validate: the parameter h has a key :namecheap_user and it is a string
                errors << "The parameter h does not have a key :namecheap_user or it is not a string" unless h.has_key?(:namecheap_user) && h[:namecheap_user].is_a?(String)
                # validate: the parameter h has a key :namecheap_username and it is a string
                errors << "The parameter h does not have a key :namecheap_username or it is not a string" unless h.has_key?(:namecheap_username) && h[:namecheap_username].is_a?(String)
                # validate: the parameter h has a key :namecheap_client_ip and it is a string
                errors << "The parameter h does not have a key :namecheap_client_ip or it is not a string" unless h.has_key?(:namecheap_client_ip) && h[:namecheap_client_ip].is_a?(String)
                # validate: if exists :nodes, it most be an array, and each element must be a valid descritor of BlackStack::MtaDeployer::NodeModule
                if h.has_key?(:nodes)
                    errors << "The parameter h[:nodes] is not an array" unless h[:nodes].is_a?(Array)
                    if h[:nodes].is_a?(Array)
                        h[:nodes].each do |node|
                            errors += BlackStack::MtaDeployer::NodeModule.descriptor_errors(node)
                        end
                    end # if h[:nodes].is_a?(Array)
                end
            end # if h.is_a?(Hash)
            # return
            errors
        end

        # set the variables
        def self.set(h={})
            # validate the configuration descriptor
            errors = self.descriptor_errors(h)
            if errors.size > 0
                # raise an exception
                raise errors.join("\n")
            end
            # set the variables
            @@namecheap_api_key = h[:namecheap_api_key]
            @@namecheap_user = h[:namecheap_user]
            @@namecheap_username = h[:namecheap_username]
            @@namecheap_client_ip = h[:namecheap_client_ip]
        end


    end
end
