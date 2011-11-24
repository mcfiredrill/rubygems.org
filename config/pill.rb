log_file = "#{RELEASE_PATH}/shared/log/bluepill.log"
base_dir = "/tmp/bluepill"

Bluepill.application("gemcutter", :log_file => log_file, :base_dir => base_dir) do |app|
  app.process("delayed_job") do |process|
    process.working_dir = "#{RELEASE_PATH}/current"

    process.start_grace_time    = 10.seconds
    process.stop_grace_time     = 10.seconds
    process.restart_grace_time  = 10.seconds
    process.checks :mem_usage, :every => 10.seconds, :below => 400.megabytes, :times => 3

    process.environment = { 'RAILS_ENV' => RAILS_ENV }
    process.start_command = "script/delayed_job start"
    process.stop_command  = "script/delayed_job stop"

    process.pid_file = "#{RELEASE_PATH}/shared/pids/delayed_job.pid"

    process.uid = process.gid = "rubycentral"
    process.supplementary_groups = ['rvm']
  end
end
