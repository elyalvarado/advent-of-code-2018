def parse_log_entry log
  minute = log[15..16].to_i
  type = nil
  guard = nil
  if log =~ /shift/
    type = 'shift start'
    guard = log.split(' ')[3]
    guard = guard[1..guard.length].to_i
  elsif log =~ /asleep/
    type = 'asleep'
  elsif log =~ /wakes/
    type = 'awake'
  end
  { minute: minute, type: type, guard: guard }
end

def process_logs logs
  sorted_logs = logs.sort
  @guards_minutes = {}
  @current_guard = nil
  @asleep_minute = nil
  sorted_logs.each do |log|
    parsed_log = parse_log_entry(log)
    case parsed_log[:type]
    when 'shift start'
      @current_guard = parsed_log[:guard]
    when 'asleep'
      @asleep_minute = parsed_log[:minute]
    when 'awake'
      awake_minute = parsed_log[:minute]
      @guards_minutes[@current_guard] ||= { total: 0, minute_from_hour: {} }
      @guards_minutes[@current_guard][:total] += awake_minute - @asleep_minute
      (@asleep_minute...awake_minute).each do |m|
        @guards_minutes[@current_guard][:minute_from_hour][m] ||= { sleep_count: 0 }
        @guards_minutes[@current_guard][:minute_from_hour][m][:sleep_count] += 1
      end
    end
  end
  @guards_minutes
end

def most_minutes_asleep logs
 processed_logs = process_logs(logs)
 guard_with_most_minutes = processed_logs.max_by { |x| x[1][:total] }
 minute_most_sleep = guard_with_most_minutes[1][:minute_from_hour].max_by { |m| m[1][:sleep_count] }
 guard_with_most_minutes[0]*minute_most_sleep[0]
end

if __FILE__ == $0
  log_entries = File.open("#{__dir__}/input.txt",'r').readlines
  puts most_minutes_asleep(log_entries)
end