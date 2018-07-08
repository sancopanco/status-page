module StatusPage
  module Format
    class CSV
      def format(services, live=true)
        services.each do |service|
          printf("%s, %s, %s\n", 
            service.name, 
            service.status(live), 
            service.time)  
        end
      end
    end
  end
end