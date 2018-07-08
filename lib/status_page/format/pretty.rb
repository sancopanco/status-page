module StatusPage
  module Format
    class Pretty
      def format(services, live=true)
        services.each do |service|
          printf("%s\n", service.name)
          printf("   %-10s %s\n", "status:", service.status(live))
          printf("   %-10s %s\n", "time:", service.time)
        end
      end
    end
  end
end