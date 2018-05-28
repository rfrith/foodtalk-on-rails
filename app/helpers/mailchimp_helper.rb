module MailchimpHelper

  include Notifications

  def subscribe_email_to_list(email, list_id, first_name, last_name)
    if(!email_has_been_added_to_list(Digest::MD5.hexdigest(email.downcase), list_id))
      gibbon = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
      gibbon.lists(list_id).members.create(body: {email_address: email, status: "subscribed", merge_fields: {FNAME: first_name, LNAME: last_name}})
    else
      gibbon = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
      gibbon.lists(list_id).members(Digest::MD5.hexdigest(email.downcase)).update(body: { status: "subscribed" })
    end
  end

  def un_subscribe_email_from_list(email_as_md5_hash, list_id)
    if(email_has_been_added_to_list(email_as_md5_hash, list_id))
      gibbon = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
      gibbon.lists(list_id).members(email_as_md5_hash).update(body: { status: "unsubscribed" })
    end
  end

  def all_enabled_lists
    lists = {}
    Rails.application.secrets.mailchimp_list_ids.split(',').each do |id|
      gibbon = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
      response = gibbon.lists(id).retrieve(params: {"fields": "id,name"})
      lists.store(response.body["id"], response.body["name"])
    end
    return lists
  end
  
  def email_has_been_added_to_list(email_as_md5_hash, list_id)
    begin
      gibbon = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
      #TODO: is there a better way to do this?
      result = gibbon.lists(list_id).members(email_as_md5_hash).retrieve
      return true
    rescue Gibbon::MailChimpError => e
      return false
    end
  end

  def email_is_subscribed_to_list(email_as_md5_hash, list_id)
    begin
      gibbon = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
      result = gibbon.lists(list_id).members(email_as_md5_hash).retrieve
      if(result.body['status'] == "subscribed")
        return true
      elsif(result.body['status'] == "unsubscribed")
        return false
      else
        logger.info("Unknown subscription status.")
        return false
      end
    rescue Gibbon::MailChimpError => e
      return false
    end
  end

end