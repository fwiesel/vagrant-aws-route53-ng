require 'vagrant'

module VagrantPlugins
  module Route53NG
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :hosted_zone_id
      attr_accessor :record_set
      attr_accessor :ip_type
      attr_accessor :ip
      attr_accessor :region
      attr_accessor :access_key_id
      attr_accessor :secret_access_key

      def initialize
        @hosted_zone_id   = UNSET_VALUE
        @record_set       = UNSET_VALUE
        @ip_type          = UNSET_VALUE
        @ip               = UNSET_VALUE
        @region           = UNSET_VALUE
        @access_key_id    = UNSET_VALUE
        @secret_access_key= UNSET_VALUE
      end

      def validate(machine)
        errors = _detected_errors

        if @hosted_zone_id != UNSET_VALUE && @record_set != UNSET_VALUE
          errors << "config.route53.ip_type must be :public or :private" \
            unless [ :public, :private ].include?(@ip_type) or @ip != UNSET_VALUE
        end

        { 'Route53NG' => errors }
      end
    end
  end
end
