module ForemanMco::Command
  class Filter
    def self.identity_filter(val)
      {:identity => val}
    end

    def self.class_filter(val)
      {:class => val}
    end

    def self.fact_filter(val)
      {:fact => val}
    end
  end
end