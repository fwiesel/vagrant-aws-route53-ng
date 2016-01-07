require 'vagrant'

module VagrantPlugins
  module AwsRoute53
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :hosted_zone_id
      attr_accessor :record_set
      attr_accessor :ip_type

      def initialize
        @hosted_zone_id = UNSET_VALUE
        @record_set     = UNSET_VALUE
        @ip_type        = :public
      end

      def validate(machine)
        errors = _detected_errors

        raise "config.route53.ip_type must be :public or :private." \
          unless [ :public, :private ].include?(@ip_type)

        { 'AwsRoute53' => errors }
      end
    end
  end
end
