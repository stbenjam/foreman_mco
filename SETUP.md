# MCollective setup

## Install MCollective on your nodes

You can setup any node as a MCollective proxy. MCollective doesn't have an idea of a master and slave so any host can run a command across any other node in the collective. You might want to install your proxy on the same machine as where your AMQP server runs just for the sake of management, but other than that it doesn't matter.

## Install the plugin for Foreman

It's recommended that you use a git-based installation of foreman core for now because the plugin is not yet packaged as a RPM or deb. There are instructions on how to do that [here](http://theforeman.org/manuals/1.1/index.html#3.4InstallFromSource).

Once that's done you can clone the plugin and then add it to your gemfile:

1. `mkdir plugins`
2. `git clone https://github.com/witlessbird/foreman_mco plugins/foreman_mco`
3. `echo "gem 'foreman-mco', :path => 'plugins/foreman_mco'" >> bundler.d/Gemfile.local.rb`
4. `RAILS_ENV=production rake db:migrate`
5. `touch tmp/restart.txt`

## Install smart-proxy from git

Next, we'll setup the proxy and necessary workers. But first, you need to install Redis; if you're already got EPEL enabled, just run `yum install -y redis && /etc/init.d/redis start && chkconfig redis on`. There are some additional settings that should be tweaked to run a queue on top of Redis in production, but those fall outside the scope of this document.

Then, run the following steps.

1. `git clone -b mcollective https://github.com/skottler/smart-proxy`
2. `bundle install`
3. `cp config/settings.yaml.example config/settings.yaml`
4. Set the `:mcollective` option to true in config/settings.yaml
5. `bundle install`
6. `bundle exec ./bin/smart-proxy`
7. (in a different shell) `bundle exec ./bin/async-workers`

## Add MCollective proxy to Foreman
If you've already got the machine you're going to be using as your MCollective proxy setup as a smart-proxy in your Foreman instance, then just click the "Refresh Features" button on the proxy listing page. If not, then you'll need to add your new proxy in Foreman. Make sure port 3000 is open to your Foreman instance's address.

You should now have an option on the host and hostgroup edit page to assign that host or hostgroup a default MCollective proxy. There is no validation right now to ensure the host is part of the collective of the proxy it's assigned so please make sure the target host and proxy host and running on the same collective.

Finally, edit `config/settings.yml` on the proxy so jobs can alert Foreman to they are complete.
