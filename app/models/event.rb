class Event
  attr_accessor :calendar
  attr_accessor :summary
  attr_accessor :begin_time
  attr_accessor :end_time
  attr_accessor :attendees
  attr_accessor :organizer
  attr_accessor :rejected
  attr_accessor :all_day
  attr_accessor :client
  attr_accessor :welcome
  attr_accessor :meeting_event

  def initialize(calendar, json)
    @calendar = calendar
    if json.present?
      @summary = json.summary
      @all_day = json.start.date_time.blank?
      @begin_time = parse_begin_time(json.start.date_time)
      @end_time = parse_end_time(json.end.date_time)
      @attendees = parse_attendees(json.attendees)
      @organizer = parse_attendee(json.organizer)
      @rejected = parse_rejected(json.attendees)
      @client = parse_client(json.summary)
      @welcome = parse_welcome(json.summary)
      @meeting_event = parse_meeting_event(json.summary)
    end
  end

  def as_json
    {
      summary: summary,
      begin_time: begin_time,
      end_time: end_time,
      attendees: attendees,
      rejected: rejected,
      all_day: all_day,
      client: summary,
      welcome: summary,
      meeting_event: summary
    }
  end

  def all_day?
    @all_day
  end

  def duration
    end_time.to_i - begin_time.to_i
  end

  def overlapping?
    calendar.events.any? do |event|
      next if event == self

      (event.begin_time <= begin_time && event.end_time > begin_time) ||
        (event.begin_time < end_time && event.end_time >= end_time)
    end
  end

  def getImage(attendee)
    image = "placeholder-thumbnail.jpg"
    case attendee 
    when "stuart.h@threesixtyeight.is", "stuart.h@threesixtyeight.com"
      image = "stuart-thumbnail.jpg"
    when "shelby.b@threesixtyeight.is", "shelby.b@threesixtyeight.com"
      image = "shelby-thumbnail.jpg"
    when "corey.s@threesixtyeight.is", "corey.s@threesixtyeight.com"
      image = "corey-thumbnail.jpg"
    when "tara.h@threesixtyeight.is", "tara.h@threesixtyeight.com"
      image = "tara-thumbnail.jpg"
    when "ebony.s@threesixtyeight.is", "ebony.s@threesixtyeight.com"
      image = "ebony-thumbnail.jpg"
    when "gus.m@threesixtyeight.is", "gus.m@threesixtyeight.com"
      image = "gus-thumbnail.jpg"
    when "hailey.j@threesixtyeight.is", "hailey.j@threesixtyeight.com"
      image = "hailey-thumbnail.jpg"
    when "jeremy.b@threesixtyeight.is", "jeremy.b@threesixtyeight.com"
      image = "jeremy-thumbnail.jpg"
    when "justin.h@threesixtyeight.is", "justin.h@threesixtyeight.com"
      image = "justin-thumbnail.jpg"
    when "nick.d@threesixtyeight.is", "nick.d@threesixtyeight.com"
      image = "nick-thumbnail.jpg"
    when "sherin.d@threesixtyeight.is", "sherin.d@threesixtyeight.com"
      image = "sherin-thumbnail.jpg"
    when "tim.r@threesixtyeight.is", "tim.r@threesixtyeight.com"
      image = "tim-thumbnail.jpg"
    when "tj.b@threesixtyeight.is", "tj.b@threesixtyeight.com"
      image = "tj-thumbnail.jpg"
    when "adam.g@threesixtyeight.is", "adam.g@threesixtyeight.com"
      image = "adam-thumbnail.jpg"
    when "bri.e@threesixtyeight.is", "bri.e@threesixtyeight.com"
      image = "bri-thumbnail.jpg"
    when "cody.c@threesixtyeight.is", "cody.c@threesixtyeight.com"
      image = "cody-thumbnail.jpg"
    when "kara.p@threesixtyeight.is", "kara.p@threesixtyeight.com"
      image = "kara-thumbnail.jpg"
    when "phil.r@threesixtyeight.is", "phil.r@threesixtyeight.com"
      image = "phil-thumbnail.jpg"
    when "carolina.m@threesixtyeight.is", "carolina.m@threesixtyeight.com"
      image = "carolina-thumbnail.jpg"
    when "maria.d@threesixtyeight.is", "maria.d@threesixtyeight.com"
      image = "maria-thumbnail.jpg"
    end
    image
  end

  private

  def parse_begin_time(begin_time)
    begin_time.presence || Date.current.beginning_of_day + 8.hours
  end

  def parse_end_time(end_time)
    end_time.presence || Date.current.end_of_day - 6.hours
  end

  def parse_attendees(attendees)
    return [] if attendees.blank?

    attendees.reject(&:resource).find_all do |attendee|
      attendee.response_status == "accepted"
    end.map do |attendee|
      parse_attendee(attendee)
    end
  end

  def parse_attendee(attendee)
    return '' if attendee.blank?
    name = attendee.email
    name
  end

  def parse_rejected(attendees)
    return false if attendees.blank?

    attendees.detect(&:resource).try(:response_status) != "accepted"
  end

  def parse_client(summary)
    return '' if summary.blank?
    summary[/(?<=\[).+?(?=\])/]
  end

  def parse_welcome(summary)
     if summary.include?("[") == false
      return "Welcome!" 
  else
    return "Welcome, "
    end
  end

  def parse_meeting_event(summary)
    if summary.include?("[") == false
      return 'Next opening is at'
    else
      return ', next opening is at'
    end
  end
end
