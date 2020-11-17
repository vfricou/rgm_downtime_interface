module Notifications
  module Mails
    class SendService < BaseService
      def initialize(notification,mails)
        @notification = notification
        @mails = mails
      end

      def call
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
        message_body << '    <tr>'
        message_body << '      <th class="alert-table-th" width="150">Level</th>'
        message_body << '      <th class="alert-table-th" width="250">Name</th>'
        message_body << '      <th class="alert-table-th" width="150">Cause</th>'
        message_body << '      <th class="alert-table-th" width="150">Start Date</th>'
        message_body << '      <th class="alert-table-th" width="150">End Date</th>'
        message_body << '  </tr>'
        message_body << '  <tr>'
        message_body << '    <td colspan="6">'
        @notification.each do |object|
          if object['type'] == 'application'
            message_body << '      <table cellspacing="0" cellpadding="0">'
            message_body << '         <tbody>'
            message_body << '           <tr>'
            message_body << '<td class="alert-table-td" width="150">'+object['level']+'</td>'
            message_body << '<td class="alert-table-td" width="250">'+object['app']+'</td>'
            message_body << '<td class="alert-table-td" width="150">'+object['cause']+'</td>'
            message_body << '<td class="alert-table-td" width="150">'+object['startdate']+'</td>'
            message_body << '<td class="alert-table-td" width="150">'+object['enddate']+'</td>'
            message_body << '            </tr>'
            message_body << '         </tbody>'
            message_body << '       </table>'
          elsif object['type'] == 'host'
            message_body << '      <table cellspacing="0" cellpadding="0">'
            message_body << '         <tbody>'
            message_body << '           <tr>'
            message_body << '<td class="alert-table-td" width="150">'+object['host']+'</td>'
            message_body << '<td class="alert-table-td" width="250">-</td>'
            message_body << '<td class="alert-table-td" width="150">'+object['cause']+'</td>'
            message_body << '<td class="alert-table-td" width="150">'+object['startdate']+'</td>'
            message_body << '<td class="alert-table-td" width="150">'+object['enddate']+'</td>'
            message_body << '            </tr>'
            message_body << '         </tbody>'
            message_body << '       </table>'
          elsif object['type'] == 'service'
            message_body << '      <table cellspacing="0" cellpadding="0">'
            message_body << '         <tbody>'
            message_body << '           <tr>'
            message_body << '<td class="alert-table-td" width="150">'+object['host']+'</td>'
            message_body << '<td class="alert-table-td" width="250">'+object['service']+'</td>'
            message_body << '<td class="alert-table-td" width="150">'+object['cause']+'</td>'
            message_body << '<td class="alert-table-td" width="150">'+object['startdate']+'</td>'
            message_body << '<td class="alert-table-td" width="150">'+object['enddate']+'</td>'
            message_body << '            </tr>'
            message_body << '         </tbody>'
            message_body << '       </table>'
          end
        end
        message_body << '    </td>'
        message_body << '  </tr>'
        message_body << '</tbody>'

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
          message = message_content + "\n" + message_body
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
