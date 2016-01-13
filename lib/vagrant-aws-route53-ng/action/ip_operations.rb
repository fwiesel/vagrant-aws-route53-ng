require 'aws-sdk-v1'

module VagrantPlugins
  module Route53NG
    module Action
      class IpOperations
        private
        def config(environment)
          config          = environment[:machine].config
          provider_config = environment[:machine].provider_config

          access_key_id     = provider_config.access_key_id
          secret_access_key = provider_config.secret_access_key
          region            = provider_config.region
          instance_id       = environment[:machine].id
          hosted_zone_id    = config.route53.hosted_zone_id
          record_set        = config.route53.record_set
          ip_type           = config.route53.ip_type

          return access_key_id, hosted_zone_id, instance_id, record_set, ip_type, region, secret_access_key
        end

        def set(options)
          ::AWS.config(access_key_id: options[:access_key_id], secret_access_key: options[:secret_access_key], region: options[:region])

          ec2 = ::AWS.ec2
          instance = ec2.instances[options[:instance_id]]

          ip_address =
            options[:ip] ||
              case options[:ip_type]
                when :public
                  instance.public_ip_address
                when :private
                  instance.private_ip_address
                else
                  nil
              end

          raise "ip and ip_type are both nil - should never happen?" unless ip_address

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

          nil
        end
      end
    end
  end
end
