class Calendar
  include ActionView::Helpers::DateHelper
  attr_accessor :calendar_id
  attr_accessor :location
  attr_accessor :google_events
  attr_writer :events

  def initialize(calendar_data, calendar_service = nil)
    @location = parse_location(calendar_data.try(:summary))
    @calendar_id = calendar_data.try(:id)
    @calendar_service = calendar_service
  end

  def events
    @events ||= @calendar_service.list_events(
        @calendar_id,
        order_by: "starttime",
        single_events: true,
        time_min: DateTime.now.beginning_of_day.rfc3339,
        time_max: DateTime.now.end_of_day.rfc3339).items.map { |item| Event.new(self, item) }
  end

  def as_json
    calendar_json = {name: location, calendar_id: calendar_id}
    calendar_json[:events] = events.map(&:as_json) if events.present?
    calendar_json
  end

  def add_event(calendar_id, event)
    @cal_result = @calendar_service.insert_event(calendar_id, event)
  end

  def celebration
    d = DateTime.now.strftime("%d/%m")
    celebrationMessage = ""
    celebrations = {
        "04/01" => "Happy Workiversary, Shelby!",
        "15/01" => "Happy Birthday, Tara!",
        "19/01" => "Happy Birthday, Ebony!",
        "21/01" => "Happy Birthday, Raina!",
        "27/01" => "Happy Birthday, Nick!",
        "15/02" => "Happy Workiversary, Corey!",
        "18/02" => "Happy Birthday, Maxel!",
        "25/02" => "Happy Birthday, Philip!",
        "12/03" => "Happy Birthday, Corey!",
        "01/03" => "Happy Birthday, ThreeSixtyEight!!!",
        "18/04" => "Happy Birthday, Kara!",
        "06/05" => "Happy Birthday, Sherin!",
        "11/05" => "Happy Workiversary, Tara!",
        "16/05" => "Happy Workiversary, Bo!",
        "22/05" => "HBD, Jeremy! HW, Justin!" ,
        "02/06" => "Happy Birthday, Shelby!",
        "14/06" => "Happy Birthday, Gus!",
        "20/08" => "Happy Birthday, Adam!",
        "21/08" => "Happy Workiversary, Ebony!",
        "29/08" => "Happy Workiversary, Adam!",
        "02/09" => "Happy Birthday, Kenny!",
        "25/09" => "Happy Workiversary, Phil!",
        "26/09" => "Happy Workiversary, Kara!",
        "04/10" => "Happy Birthday, Sahil!",
        "01/11" => "Happy Workiversary, Sahil!",
        "29/11" => "Happy Birthday, Stu!",
        "01/12" => "Happy Workiversary, Maxel!",
        "05/12" => "Happy Birthday, Justin!"
    }
    celebrations.each do |date, message| 
      if d == date 
        celebrationMessage = message
      end
    end
    celebrationMessage
  end 

  def description
    if in_use?
      "This room is used by #{current_event.organizer} " \
        "until #{current_event.end_time.strftime("%l:%M %P")}."
    else
      "This room is available"
    end
  end

  def exclamation
    positive = ["Woohoo!", "Aw yeah!", "Boo-yah!", "Huzzah!", "Shazam!"]
    negative = ["Shucks!", "Oh no!", "Bummer!", "Dagnabbit!", "Good grief!"]
    random = rand(5)
    if in_use?
      negative[random] + "\n"
    else
      positive[random] + "\n"
    end
  end

  def time_left(suffix: "")
    if in_use?
      if current_event.all_day?
        "this meeting takes all day"
      else
        distance_of_time_in_words(Time.zone.now, current_event.end_time) + suffix
      end
    else
      if next_event.present?
        distance_of_time_in_words(Time.zone.now, next_event.begin_time) + suffix
      else
        ""
      end
    end
  end

  def next_event
    events
        .reject(&:rejected)
        .sort_by(&:begin_time)
        .detect { |event| event.begin_time > Time.zone.now }
  end

  def after_event(next_event)
    events
        .reject(&:rejected)
        .sort_by(&:begin_time)
        .detect { |event| event.begin_time > next_event.begin_time  }
  end

  def available?
    current_event.nil?
  end

  def in_use?
    !available?
  end

  def current_event
    events.detect do |event|
      next if event.rejected

      event.all_day? ||
          Time.zone.now >= event.begin_time && Time.zone.now <= event.end_time
    end
  end

  private

  def parse_location(location)
    return '' if location.blank?
    location.gsub(/\s*\(.*\)/, "")
  end
end
