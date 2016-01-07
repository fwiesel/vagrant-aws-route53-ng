# -*- coding: utf-8 -*-
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'
Vagrant.require_version '>= 1.6.5'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box       = 'dummy'
  config.ssh.username = "#{ENV['EC2_SSH_USERNAME']}"

  config.vm.provider :aws do |aws, override|
    aws.region                      = 'ap-northeast-1'
    aws.security_groups             = ['vagrant']
    aws.instance_type               = 't2.medium'
    aws.ami                         = "#{ENV['EC2_AMI']}"
    aws.access_key_id               = "#{ENV['AWS_ACCESS_KEY_ID']}"
    aws.secret_access_key           = "#{ENV['AWS_SECRET_ACCESS_KEY']}"
    aws.tags                        = {'Name' => "#{ENV['EC2_INSTANCE_NAME']}"}
    override.ssh.private_key_path   = "#{ENV['EC2_PRIVATE_KEY_PATH']}"
    override.route53.hosted_zone_id = "#{ENV['ROUTE53_HOSTED_ZONE_ID']}"
    override.route53.record_set     = ["#{ENV['ROUTE53_DOMAIN']}", 'A']
    override.route53.ip_type        = :public

    override.ssh.insert_key = false
  end
end
