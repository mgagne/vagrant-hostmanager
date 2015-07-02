module VagrantPlugins
  module HostManager
    class Command < Vagrant.plugin('2', :command)
      include HostsFile

      def execute
        options = {}
        options[:parallel] = false
        opts = OptionParser.new do |o|
          o.banner = 'Usage: vagrant hostmanager [vm-name]'
          o.separator ''

          o.on("--[no-]parallel",
               "Enable or disable parallelism") do |parallel|
            options[:parallel] = parallel
          end

          o.on('--provider provider', String,
            'Update machines with the specific provider.') do |provider|
            options[:provider] = provider
          end
        end

        argv = parse_options(opts)
        options[:provider] ||= @env.default_provider

        generate(@env, options[:provider].to_sym)

        @env.batch(options[:parallel]) do |batch|
          with_target_vms(argv, options) do |machine|
            batch.custom(machine) do |m|
              update(m)
            end
          end
        end
      end
    end
  end
end
