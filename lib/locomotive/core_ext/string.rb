class String #:nodoc

  def permalink(underscore = false)
    _permalink = self.gsub(/[\s]+/, '_')
    underscore ? _permalink.underscore : _permalink
  end

  def permalink!(underscore = false)
    replace(self.permalink(underscore))
  end

  alias :parameterize! :permalink!
end
