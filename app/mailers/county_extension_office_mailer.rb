class CountyExtensionOfficeMailer < ApplicationMailer
  default from: 'snap-ed@uga.edu'

  def program_completions_email
    @county_extension_office = params[:county_extension_office]
    @zip_code = params[:zip_code]
    date_range = params[:date_range]

    format = "%b %d, %Y"
    @start_date = date_range.first.strftime(format)
    @end_date = date_range.last.strftime(format)

    @users = params[:users]

    listserv = Rails.application.secrets.ext_office_notify_listserv

    if(Rails.application.secrets.ext_office_notify_test)
      to = listserv
      cc = nil
    else
      to = @county_extension_office.email
      cc = listserv
    end

    subject = "eLearning Program Completion Report for #{@county_extension_office.name} #{@start_date} - #{@end_date}"

    mail(to: to, cc: cc, subject: subject)

  end
end
