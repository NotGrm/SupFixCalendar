#require 'ftools'
require 'icalendar'

class HomeController < ApplicationController
  def home
  end

  def file_upload
  	tmp = params[:ics].tempfile

  	if File.extname(tmp) == ".ics"
		file = Tempfile.new(["fixed", ".ics"], 'tmp')
		converted = convert(tmp)

		begin
			file.write(converted.to_ical)
			send_file file.path
		ensure
			file.close
			file.unlink   # deletes the temp file
		end
	else
		flash.now[:error] = 'Your file extension is not .ics'
		render action: "home"
	end

  end

  private
  def convert(file)
  	cals = Icalendar.parse(file)
	cal = cals.first

	converted = Icalendar::Calendar.new

	# Now you can access the cal object in just the same way I created it
	cal.events.each do |event|
		event.dtstart.icalendar_tzid = ""
		event.dtend.icalendar_tzid = ""

		converted.add_event(event)
	end

	return converted
  end
end
