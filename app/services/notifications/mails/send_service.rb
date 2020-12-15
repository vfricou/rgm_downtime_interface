module Notifications
  module Mails
    class SendService < BaseService
      def initialize(notification,mails)
        @notification = notification
        @mails = mails
      end

      def call

        tr_open = '    <tr>'
        tr_close = '    </tr>'
        td_close = '</td>'
        td_width_normal = '      <td class="alert-table-td" width="150">'
        td_width_long = '      <td class="alert-table-td" width="250">'

        message_content = "From: #{Rails.configuration.rgmdwt[:notification][:mail][:from]}\n"
        message_content << ''
        message_content << "MIME-Version: 1.0\n"
        message_content << "Content-Type: text/html\n"
        message_content << "Subject: #{Rails.configuration.rgmdwt[:notification][:mail][:subject]}\n"
        message_body = '<style type="text/css">'
        message_body << '  .alert-table{'
        message_body << '    border: 1px solid #eee;'
        message_body << '    margin: 0px;'
        message_body << '    padding: 0px;'
        message_body << '  }'
        message_body << '  .alert-table-th{'
        message_body << '    text-align: left;'
        message_body << '    border-bottom: 2px solid #eee;'
        message_body << '    padding: 5px;'
        message_body << '    color: #ffffff;'
        message_body << '    background-color: #646883;'
        message_body << '    font-family: helvetica;'
        message_body << '    font-size: 16px;'
        message_body << '  }'
        message_body << '  .alert-table-td{'
        message_body << '    border-left: 1px solid #eee;'
        message_body << '    text-align: left;'
        message_body << '    border-bottom: 1px solid #eee;'
        message_body << '    padding: 5px;'
        message_body << '    font-family: helvetica;'
        message_body << '    font-size: 15px;'
        message_body << '  }'
        message_body << '  .even{'
        message_body << '    background:#f6f6f8;'
        message_body << '  }'
        message_body << ''
        message_body << '  .odd{'
        message_body << '    background:#ffffff;'
        message_body << '  }'
        message_body << '</style>'
        message_body << '<p> A new notification has been setup. </p>'
        message_body << '<br>'
        message_body << '<table class="alert-table" cellspacing="0" cellpadding="0">'
        message_body << '  <tbody>'
        message_body << tr_open
        message_body << '      <th class="alert-table-th" width="150">Level</th>'
        message_body << '      <th class="alert-table-th" width="250">Name</th>'
        message_body << '      <th class="alert-table-th" width="150">Cause</th>'
        message_body << '      <th class="alert-table-th" width="150">Start Date</th>'
        message_body << '      <th class="alert-table-th" width="150">End Date</th>'
        message_body << tr_close
        @notification.each do |object|
          case object['type']
          when 'application'
            message_body << tr_open
            message_body << td_width_normal + object['level'] + td_close
            message_body << td_width_long + object['app'] + td_close
            message_body << td_width_normal + object['cause'][0] + td_close
            message_body << td_width_normal + object['startdate'] + td_close
            message_body << td_width_normal + object['enddate'] + td_close
            message_body << tr_close
          when 'host'
            message_body << tr_open
            message_body << td_width_normal + object['host'] + td_close
            message_body << "#{td_width_long}-#{td_close}"
            message_body << td_width_normal + object['cause'][0] + td_close
            message_body << td_width_normal + object['startdate'] + td_close
            message_body << td_width_normal + object['enddate'] + td_close
            message_body << tr_close
          when 'service'
            message_body << tr_open
            message_body << td_width_normal + object['host'] + td_close
            message_body << td_width_long + object['service'] + td_close
            message_body << td_width_normal + object['cause'][0] + td_close
            message_body << td_width_normal + object['startdate'] + td_close
            message_body << td_width_normal + object['enddate'] + td_close
            message_body << tr_close
          end
        end
        message_body << '  </tbody>'
        message_body << '</table>'

        auth_type = Rails.configuration.rgmdwt[:notification][:mail][:type].present? ? Rails.configuration.rgmdwt[:notification][:mail][:type] : nil
        smtp = Net::SMTP.new(
          Rails.configuration.rgmdwt[:notification][:mail][:host],
          Rails.configuration.rgmdwt[:notification][:mail][:port]
        ).start(
          Rails.configuration.rgmdwt[:notification][:mail][:helo],
          Rails.configuration.rgmdwt[:notification][:mail][:user],
          Rails.configuration.rgmdwt[:notification][:mail][:pass],
          auth_type
        )
        smtp.enable_ssl unless Rails.configuration.rgmdwt[:notification][:mail][:ssl].nil?

        @mails.each do |mail_to|
          message_content << "To: #{mail_to}\n"
          message = "#{message_content}\n#{message_body}"
          begin
            Rails.logger.info "Sending mail to #{mail_to}"
            smtp.send_message message, Rails.configuration.rgmdwt[:notification][:mail][:from], mail_to
          rescue StandardError => e
            Rails.logger.error("Unable to send email with exception : #{e.message}")
          end
        end
      end
    end
  end
end
