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
    mail(to: @county_extension_office.email, cc: "FOODTALK-NOTIFY@listserv.uga.edu", subject: "eLearning Program Completion Report for #{@county_extension_office.name} #{@start_date} - #{@end_date}")

  end
end
