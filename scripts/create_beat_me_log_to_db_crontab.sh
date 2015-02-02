SCRIPTS_PATH=$(pwd)
NODE_PATH=$(which node)
COMMAND="perl $SCRIPTS_PATH/beat_me_log_to_json.pl 2>&1 >> /data/log/crontab.log && $NODE_PATH $SCRIPTS_PATH/load_beat_me_log_json_to_db.js 2>&1 >> /data/log/crontab.log"

echo "5 0 * * * $COMMAND"
