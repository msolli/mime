if defined?(Footnotes) && Rails.env.development?
  Footnotes.run!
  # ... other init code
end
