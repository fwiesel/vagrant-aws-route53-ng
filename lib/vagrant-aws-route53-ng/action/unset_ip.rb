require 'aws-sdk-v1'
require_relative 'ip_operations'

module VagrantPlugins
  module Route53NG
    module Action
      class UnsetIp < IpOperations
        def initialize(app, environment)
          @app = app
        end

        def call(environment)
          options = config(environment)

          return @app.call(environment) \
            if options[:hosted_zone_id].eql?(::Vagrant::Plugin::V2::Config::UNSET_VALUE) ||
              options[:record_set].eql?(::Vagrant::Plugin::V2::Config::UNSET_VALUE)

          set(options.merge(ip: '0.0.0.0')) do |instance_id, ip, record_set|
            environment[:ui].info("#{ip} has been assigned to #{record_set[0]}[#{record_set[1]}]")
          end

          @app.call(environment)
        end
      end
    end
  end
end
