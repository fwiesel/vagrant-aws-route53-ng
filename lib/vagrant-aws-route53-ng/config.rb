require 'vagrant'

module VagrantPlugins
  module Route53NG
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :hosted_zone_id
      attr_accessor :record_set
      attr_accessor :ip_type

      def initialize
        @hosted_zone_id = UNSET_VALUE
        @record_set     = UNSET_VALUE
        @ip_type        = UNSET_VALUE
      end

      def finalize!
        @ip_type = :public if (@ip_type == UNSET_VALUE && @hosted_zone_id != UNSET_VALUE)
      end

      def validate(machine)
        errors = _detected_errors

        errors << "config.route53.ip_type must be :public or :private." \
          unless [ :public, :private ].include?(@ip_type) && @hosted_zone_id != UNSET_VALUE

        { 'Route53NG' => errors }
      end
    end
  end
end
