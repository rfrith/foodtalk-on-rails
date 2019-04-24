module ApplicationHelper

  def create_cache_key_prefix
    key = ""
    key += request.host
    key += user_signed_in?.to_s.slice(0)
    key += @current_user.is_eligible?.to_s.slice(0)
    key += Rails.application.secrets.i18n_enabled.to_s.slice(0)
    key += I18n.locale.to_s
    return key
  end

  def get_learning_module(module_id)
    if(correct_syntax?(lesson_id))
      lesson = eval lesson_id
    end
  end

  private

  def correct_syntax? code
    stderr = $stderr
    $stderr.reopen(IO::NULL)
    RubyVM::InstructionSequence.compile(code)
    true
  rescue Exception
    false
  ensure
    $stderr.reopen(stderr)
  end

  def find_glossary_terms(text)
    found_terms = []

    glossary_terms = Rails.cache.fetch("all_glossary_terms", expires_in: 1.month) do
      GlossaryTerm.all
    end

    glossary_terms.each do |term|
      found_terms << term if (text.include? term.name)
    end
    found_terms
  end

end