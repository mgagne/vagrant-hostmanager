module VagrantPlugins
  module HostManager
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :auto_update
      attr_accessor :ignore_private_ip
      attr_accessor :aliases

      ACCEPTED_CONFIGS = [UNSET_VALUE, true, false]
      INVALID_CONFIG_MESSAGE = "A value for %s must be true, false or unset."

      def initialize
        @auto_update = UNSET_VALUE
        @ignore_private_ip = UNSET_VALUE
        @aliases = Array.new 
      end

      def finalize!
        @auto_update = true if @auto_update == UNSET_VALUE
        @ignore_private_ip = false if @ignore_private_ip == UNSET_VALUE
      end

      def validate(machine)
        errors = []

        errors << INVALID_CONFIG_MESSAGE % "hostmanager.auto_update" unless ACCEPTED_CONFIGS.include?(auto_update)
        errors << INVALID_CONFIG_MESSAGE % "hostmanager.ignore_private_ip" unless ACCEPTED_CONFIGS.include?(ignore_private_ip)

        if !machine.config.hostmanager.aliases.kind_of?(Array)
          errors << "A value for hostmanager.aliases must be an Array."
        end
        
        { "HostManager configuration" => errors }
      end
    end
  end
end
