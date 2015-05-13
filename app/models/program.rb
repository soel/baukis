class Program < ActiveRecord::Base
  has_many :entries, dependent: :destroy
  has_many :applicants, through: :entries, source: :customer
  belongs_to :registrant, class_name: 'StaffMember'

  attr_accessor :application_start_date, :application_start_hour,
    :application_start_minute, :application_end_date, :application_end_hour,
    :application_end_minute

  before_validation :set_application_start_time
  before_validation :set_application_end_time

  scope :listing, -> {
    joins('LEFT JOIN entries ON programs.id = entries.program_id')
      .select('programs.*, COUNT(entries.id) AS number_of_applicants')
      .group('programs.id')
      .order(application_start_time: :desc)
      .includes(:registrant)
  }

  private
  def set_application_start_time
    return if application_start_date.blank?
    Date.parse(application_start_date)
    if t = Time.zone.parse(application_start_date)
      self.application_start_time = t.advance(
        hours: application_start_hour.to_i,
        minutes: application_start_minute.to_i
      )
    end
  rescue ArgmentError
    self.application_start_time = nil
  end

  def set_application_end_time
    return if application_end_date.blank?
    Date.parse(application_end_date)
    if t = Time.zone.parse(application_end_date)
      self.application_end_time = t.advance(
        hours: application_end_hour.to_i,
        minutes: application_end_minute.to_i
      )
    end
  rescue ArgumentError
    self.application_end_time = nil
  end
end
