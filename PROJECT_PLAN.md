1. Scaffold a gem (template for building a gem) / 10dk
   - To achieve an app structure
   - Use `Thor` gem to create an CLI interface
   - Use rspec for testing
   - Use local HD as data store -- CSV format would be enough
   - Add dependencies
2. Design `Service` class / 30 dk
   - Responsible for getting service status info
   - attributes: url, status, status_page_css(for scraping)
   - `url`: Service provider statuspage url
   - `status`: Scrap status info from the status pages
   - `status_page_css`: required css for scraping status info
   - methods: to_csv, to_s
   - `to_csv`: Service object as CSV representation
   - `to_s`: Service object as String representation
3. Design `Storage` class / 30 dk
   - Responsible for dealing for data storage
   - attributes `file_path`
   - file_path: The path of CSV file which will be used as data storage
   - methods: save, read, backup, restore
   - `save`: Save objects to Storage -- as CVS
   - `read`: Read from Storage(Yields as data row)
   - `backup`: Creates a backup of saved data to path
   - `restore`: restore data from path
  > Not: Could have Storage as base(abstract) class and implement CVSStorage as child but  I'll use Storage class for simplicity

4. Design CLI class / 1.5h
   - Responsible for cli commands
   - Implement pull, live, history, backup, restore, status, version
    - `pull`: Pull status info from service, save it to the storage
        - Get service infos from config(.status-page.rc.yaml) and start     fething
        - Output if it needs to yell
        - Storage -> save
    - `live`: Pull and save it to the storage with loop, could have daemonize mode
    - `history`: Output saved data, Storage -> read
    - `backup`: Storage -> backup  
    - `restore`:  Storage -> restore  
    - `stats`: Summarizes the data and display in different format
      > Not: İf you use the tool without proper daemonizer(live command) 
        then the status command would be inaccurate since services 
        might have been down in the past but the storage could be out of sync
        (I'll assume that storage is consistent(constantly fetching status info))

    - `version`: Show gem version
5. Create a systemwide executable  
