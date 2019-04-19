class TestPassage < ApplicationRecord
  
  belongs_to :user
  belongs_to :test
  belongs_to :current_question, class_name: 'Question', foreign_key: 'current_question_id', optional: true
  
  before_validation :before_validation_set_first_question, on: :create
  before_update :before_update_set_next_question
  
  def accept!(answer_ids)
    if correct_answer?(answer_ids)
      self.correct_questions += 1
    end
    
    save!
  end
  
  def complited?
    current_question.nil?
  end
  
  def successful_test?
    success_rate >= 85
  end
  
  def success_rate
    correct_questions.to_f / test.questions.count.to_f * 100
  end
  
  def number_current_question
    test.questions.order(:id).where('id < ?', (current_question.id) + 1).count
  end
  private
  
  def before_validation_set_first_question
    self.current_question = test.questions.first if test.present?
  end
  
  def before_update_set_next_question
    self.current_question = next_question
  end
  
  def correct_answer?(answer_ids)
    correct_answers.ids.sort == answer_ids.map(&:to_i).sort
  end
  
  def correct_answers
    current_question.answers.correct_answers
  end
  
  def next_question
    test.questions.order(:id).where('id > ?', current_question.id).first
  end
  
end