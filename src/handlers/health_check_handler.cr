class HealthCheckHandler < Marten::Handler
    def get
      head(200)
    end
end
