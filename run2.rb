require('./Iphone_backup_parser.rb')

i = Iphone_backup_parser.new "./source2", "./destination2"
i.fix_files