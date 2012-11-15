#require 'ftools'
require 'icalendar'

class HomeController < ApplicationController
  def home
  end

  def file_upload
  	tmp = params[:ics].tempfile
    
    cals = Icalendar.parse(tmp)
	cal = cals.first

	converted = Icalendar::Calendar.new

	# Now you can access the cal object in just the same way I created it
	cal.events.each do |event|
		event.dtstart.icalendar_tzid = ""
		event.dtend.icalendar_tzid = ""

		converted.add_event(event)
	end

	file = Tempfile.new(["fixed", ".ics"], 'tmp')
	
	begin
		file.write(converted.to_ical)
		send_file file.path
	ensure
		file.close
		file.unlink   # deletes the temp file
	end

  end
end
