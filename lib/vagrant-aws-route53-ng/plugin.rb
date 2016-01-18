require 'vagrant'

module VagrantPlugins
  module Route53NG
    class Plugin < Vagrant.plugin('2')
      name 'AWS - Route 53 support'

      description <<-DESC
      DESC

      config :route53 do
        require_relative './config'
        Config
      end

      action_hook :assign_ip_to_route53, :machine_action_reload do |hook|
        require_relative './action/set_ip'
        hook.append VagrantPlugins::Route53NG::Action::SetIp
      end

      action_hook :assign_ip_to_route53, :machine_action_boot do |hook|
        require_relative './action/set_ip'
        hook.append VagrantPlugins::Route53NG::Action::SetIp
      end

      action_hook :assign_ip_to_route53, :machine_action_up do |hook|
        require_relative './action/set_ip'
        hook.append VagrantPlugins::Route53NG::Action::SetIp
      end

      action_hook :assign_ip_to_route53, :machine_action_resume do |hook|
        require_relative './action/set_ip'
        hook.append VagrantPlugins::Route53NG::Action::SetIp
      end

      action_hook :cancel_ip_from_route53, :machine_action_halt do |hook|
        require_relative './action/unset_ip'
        hook.append VagrantPlugins::Route53NG::Action::UnsetIp
      end

      action_hook :cancel_ip_from_route53, :machine_action_destroy do |hook|
        require_relative './action/unset_ip'
        hook.append VagrantPlugins::Route53NG::Action::UnsetIp
      end
    end
  end
end
