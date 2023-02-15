# frozen_string_literal: true

class PuppetLint::Report
  # Prints problems to stdout
  class StdoutReporter
    def self.format_problem(configuration, problem)
      format = log_format(configuration)

      result = "#{format}\n" % message
      result += "  #{message[:reason]}" if message[:kind] == :ignored && !message[:reason].nil?

      # Print context, if any
      if message[:check] != 'documentation' && message[:kind] != :fixed && message[:context]
        line = message[:context]
        offset = line.index(%r{\S}) || 1
        result += "\n  #{line.strip}\n"
        result += sprintf("%#{message[:column] + 2 - offset}s\n\n", '^')
      end

      result
    end

    # Retrieve the format string to be used when writing problems to STDOUT.
    # If the user has not specified a custom log format, build one for them.
    #
    # @api private
    # @return A format String to be used with String#%.
    def self.log_format(configuration)
      # TODO: this should be in the configuration itself, not in the reporter
      if configuration.log_format.nil? || configuration.log_format.empty?
        format = '%{KIND}: %{message} on line %{line}'
        format.prepend('%{path} - ') if configuration.with_filename
        format.concat(' (check: %{check})')
        configuration.log_format = format
      end

      configuration.log_format
    end
  end
end
