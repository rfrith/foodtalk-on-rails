module ApplicationHelper

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

end