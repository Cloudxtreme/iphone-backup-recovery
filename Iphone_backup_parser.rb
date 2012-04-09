#mixin for reading file chars
class File

end

class Iphone_backup_parser
  attr_accessor :inpath, :outpath, :dir

  def initialize(inpath, outpath)
    @inpath = inpath
    @outpath = outpath
    raise "input path #{inpath}doesnt exist" unless Dir.exists?(@inpath)
    raise "output path #{outpath} doesnt exist" unless Dir.exists?(@outpath)

  end

  def fix_files(params={})
    #valid params
    #:prefix - add this to all filenames
    #:mv - will move the files instead of copy (cp is default)

    if(params[:mv].nil?)
      cmd = "cp"
    else
      cmd="mv"
    end
    
    if(params[:large_file_threshold].nil?)
      large_file_threshold = 25000
    else
      large_file_threshold = params[:large_file_threshold]
    end

    Dir.entries(@inpath).each do |file|
      if(file=="." || file==".DS_Store" || file=="..")
        next
      end
     # puts "checking file #{file}"
      File.open("#{@inpath}/#{file}") do |f|
        type=nil
        buffer = f.read(10)
        #buffer.each_byte{|b| puts b.to_s(2)}
        if(!buffer.nil?)
          if(!buffer[/PNG/].nil? || !buffer[/Exif/].nil?)
            #puts "its a png"
            type=".png"
          elsif(!buffer[/JFIF/].nil?)
            type=".jpg"
          elsif(!buffer[/ftypqt/].nil?)
            #puts "its a movie"
            type=".mov"
          elsif(!buffer[/!AMR/].nil?)
            #voicemail
            type=".amr"
          else
            puts "---------------------------"
            if(!File.size?("#{@inpath}/#{file}").nil? && File.size?("#{@inpath}/#{file}") >  25000)
              puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! file size over large_file_threshold"
            end
            puts file
            puts "buffer = #{buffer}"
            next
          end
          #do the move or copy
          full_cmd = "#{cmd} #{@inpath}/#{file} #{@outpath}/#{file}#{type}"
          if(!system(full_cmd))
            puts "error #{$?}"
          end

        else
          puts "---------------------------"
          puts file
          puts "contents nil"
          next
          
          
        end


      end
    end



  end
end
