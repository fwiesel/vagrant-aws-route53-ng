require 'aws-sdk-v1'

module VagrantPlugins
  module Route53NG
    module Action
      class IpOperations
        private
        def config(environment)
          machine = environment[:machine]
          config          = machine.config
          provider_config = machine.provider_config

           {
              access_key_id:      provider_config.respond_to?(:access_key_id) && provider_config.access_key_id || config.route53.access_key_id,
              secret_access_key:  provider_config.respond_to?(:secret_access_key) && provider_config.secret_access_key || config.route53.secret_access_key,
              region:             provider_config.respond_to?(:region) && provider_config.region || config.route53.region,
              instance_id:        machine.id,
              hosted_zone_id:     config.route53.hosted_zone_id,
              record_set:         config.route53.record_set,
              ip_type:            config.route53.ip_type,
              ip:                 config.route53.ip.eql?(::Vagrant::Plugin::V2::Config::UNSET_VALUE) ? nil : config.route53.ip,
              environment:        environment
          }
        end

        def set(options)
          ::AWS.config(access_key_id: options[:access_key_id], secret_access_key: options[:secret_access_key], region: options[:region])

          ip_address = options[:ip] || begin
            instance = lambda { options[:environment][:aws_compute] && options[:environment][:aws_compute].servers.get(options[:instance_id]) || ::AWS.ec2.instances[options[:instance_id]] }

            case options[:ip_type]
              when :public
                instance.call.public_ip_address
              when :private
                instance.call.private_ip_address
              else
                nil
            end
          end

          if ip_address
            ip_address = ip_address.call(options[:environment]) if ip_address.respond_to?(:call)
            raise "ip is nil - should never happen?" unless ip_address

            record_set = {
                 name: options[:record_set][0],
                 type: options[:record_set][1],
                 resource_records: [{value: ip_address }]
            }
            record_set[:set_identifier] = options[:record_set][2] if options[:record_set][2]

            ::AWS.route_53.client.change_resource_record_sets(hosted_zone_id: options[:hosted_zone_id],
                                                              change_batch: { changes: [{ action: 'UPSERT', resource_record_set: record_set}]})
            if block_given?
              yield options[:instance_id], ip_address, options[:record_set]
            end
          end

          nil
        end
      end
    end
  end
end
