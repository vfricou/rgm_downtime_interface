module Notifications
  class SendService < BaseService
    def initialize(notification_object, mails_recipients)
      @notification_object = notification_object
      @mails_recipients = mails_recipients
    end

    def call
      Notifications::Mails::SendService.call(@notification_object,@mails_recipients) if Rails.configuration.rgmdwt[:notification][:mail][:host].present?
    end
  end
end
