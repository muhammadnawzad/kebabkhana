class HealthCheckHandler < Marten::Handler
    def get
      json({ status: "ok" })
    end
end
