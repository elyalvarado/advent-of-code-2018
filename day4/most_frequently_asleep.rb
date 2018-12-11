require_relative './most_minutes_asleep'

def most_frequently_asleep logs
  processed_logs = process_logs(logs)
  guard_most_frequently_asleep = processed_logs.max_by { |x| x[1][:minute_from_hour].max_by { |m| m[1][:sleep_count] }[1][:sleep_count] }
  minute_most_sleep = guard_most_frequently_asleep[1][:minute_from_hour].max_by { |m| m[1][:sleep_count] }
  guard_most_frequently_asleep[0]*minute_most_sleep[0]
end

if __FILE__ == $0
  log_entries = File.open("#{__dir__}/input.txt",'r').readlines
  puts most_frequently_asleep(log_entries)
end