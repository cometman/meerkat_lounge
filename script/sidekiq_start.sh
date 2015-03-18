#!/usr/bin/env bash
# Sidekiq is not running and the directory ondeck exists (which means its a deploy)
# if [ ! ps aux | grep "[s]idekiq" > /dev/null || ls /var/app/ondeck 2> /dev/null
# then 
. /opt/elasticbeanstalk/support/envvars
echo "Starting Sidekiq Job"
echo "The user running this is:"
echo `whoami`

# # Kill any exisiting sidekiq instance
# PIDFILE=$EB_CONFIG_APP_PIDS/sidekiq.pid

# if [ -f $PIDFILE ]
# then
#   SIDEKIQ_LIVES=$(/bin/ps -o pid= -p `cat $PIDFILE`)
#   if [ ! -z $SIDEKIQ_LIVES ]
#   then
#     kill -TERM `cat $PIDFILE`
#     sleep 10
#   fi
#   rm -rf $PIDFILE
# fi
RESULT=`ps -ef | awk '$8=="sidekiq" {print $2}' | grep '.*'`
if [ -z "$RESULT" ]
then
	RAILS_ENV=$RAILS_ENV bundle exec sidekiq \
	  -e $RAILS_ENV \
	  -C config/sidekiq.yml \
	  -d
fi
# Start new sidekiq instance
# SIDEKIQ=/usr/local/bin/sidekiq

# RAILS_ENV=$RAILS_ENV bundle exec $SIDEKIQ \
#   -e $RAILS_ENV \
#   -C config/sidekiq.yml \
#   -d
# fi