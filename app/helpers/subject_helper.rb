module SubjectHelper
    def subject_query(subjects)
      # clean up characters than can mess with queries
      subjects = subjects.map { |subject| subject.delete('.&').tr('+', ' ') }
      # deal with subject chaining and make a phrase
      "\"#{subjects.join.strip}\""
    end
end
