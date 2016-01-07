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
          access_key_id, hosted_zone_id, instance_id, record_set, ip_type, region, secret_access_key = config(environment)

          return @app.call(environment) \
            if hosted_zone_id.eql?(::Vagrant::Plugin::V2::Config::UNSET_VALUE) || 
               record_set.eql?(::Vagrant::Plugin::V2::Config::UNSET_VALUE)

          set(
            access_key_id:     access_key_id,
            secret_access_key: secret_access_key,
            region:            region,
            instance_id:       instance_id,
            hosted_zone_id:    hosted_zone_id,
            record_set:        record_set,
            ip:         '0.0.0.0'
          ) do |instance_id, ip, record_set|
            environment[:ui].info("#{ip} has been assigned to #{record_set[0]}[#{record_set[1]}]")
          end

          @app.call(environment)
        end
      end
    end
  end
end
