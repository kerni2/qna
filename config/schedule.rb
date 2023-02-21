env :PATH, ENV['PATH']

set :output, "#{path}/log/whenever.log"

every 1.day do
  runner "DailyDigestJob.perform_now"
end

every 5.minutes do
  rake "ts:index"
end
# Learn more: http://github.com/javan/whenever
