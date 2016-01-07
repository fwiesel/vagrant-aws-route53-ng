vagrant-aws-route53-ng
======================

This Vagrant plugin (forked from Naohiro Oogatta's [vagrant-aws-route53](https://github.com/oogatta/vagrant-aws-route53)) assigns an IP address (either public or private) of a virtual machine created via the `vagrant-aws` provider to a _pre-created_ Route 53 record set. When the instance is created or started from a stopped state, its IP--its public IP by default, unless you set `config.route53.ip_type = :private`--will be applied to the record set's `A` record. When the instance is halted or destroyed, `0.0.0.0` will be applied to the record set.

## Prerequisite ##

* vagrant-aws

## How to Install ##

```zsh
$ vagrant plugin install vagrant-aws-route53-ng
```

## Configuration Example ##

```ruby
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box       = 'dummy'

  config.vm.provider :aws do |aws, override|
    aws.ami                       = 'ami-AABBCCDD'
    aws.access_key_id             = ENV['AWS_ACCESS_KEY']
    aws.secret_access_key         = ENV['AWS_SECRET_KEY']
    aws.region                    = 'us-east-1'
    aws.instance_type             = 't2.medium'

    override.route53.hosted_zone_id = 'Z1JUXXXXXXXXXX'
    override.route53.record_set     = %w(test.oogatta.com. A)
    # Defaults to :public; use :private for internal VPC addresses
    override.route53.ip_type        = :public 
  end
end
```

## Thanks To ##
This fork of `vagrant-aws-route53-ng` was built as part of a project at [DraftKings](https://draftkings.com). They're always hiring for quality developers in the Boston region; if you're looking for a new gig, feel free to [contact me](mailto:ed+draftkings@edboxes.com) and I'll happily forward you along.

`vagrant-aws-route53` was originally developed by Naohiro Oogatta, and approximately 99.875% of the credit for this gizmo goes to him.