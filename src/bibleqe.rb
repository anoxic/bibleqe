class BibleQE
  VERSION = [0, 0, 2]

  def BibleQE.version
    VERSION.join "."
  end

  class Error < RuntimeError
  end

  class SearchError < Error
  end

  class ResultError < Error
  end
end
