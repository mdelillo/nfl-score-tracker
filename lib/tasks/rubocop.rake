if Rails.env.development?
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new(:rubocop) do |task|
    task.options = [
      '--auto-correct',
      '--display-cop-names'
    ]
  end
end
