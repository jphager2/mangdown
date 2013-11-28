require 'zip'


main_dir = File.expand_path(ARGV[0] || '.')

# main_dir = Dir.pwd + '/' + main_dir.to_s unless main_dir =~ /[a-zA-Z]:[\/\\]/

Dir.chdir(main_dir)

  def check_file_or_dir_name(name)
    num = name.slice(/(\d+)(\.jpg)*\Z/, 1)
    
    if num
      while num.length < 3
        num = '0' + num
      end
    
      name.sub(/(\d+)(\.jpg)*\Z/, num + '\2')
    end

    name
  end 

  def check_dir(dir)
    Dir.glob(dir + '/*').each do |d| 
      next if d.include?('.cbz')
      yield(d)
    end
  end 

  def validate_file_or_dir_names(dir)
    check_dir(dir) do |e|
      f = check_file_or_dir_name(e)

      unless f == e
        File.rename(e, f)
      end
    end
  end

  def cbz_dir(dir)
    zip_file_name = dir + '.cbz'
    dir += '/' unless dir[-1] == '/'

    Zip::File.open(zip_file_name, Zip::File::CREATE) do |zp|
      Dir[File.join(dir, '**', '**')].each do |file|
        zp.add(file.sub(dir, ''), file)
      end
    end
  end

  def cbz_sub_dirs(dir)
    check_dir(dir) do |d|
      cbz_dir(d)
    end
  end 

  if __FILE__ == $0
  # Make sure all sub dirs are checked
    validate_file_or_dir_names(main_dir)
  # Make sure all sub dirs have files checked
    check_dir(main_dir) { |d| validate_file_or_dir_names(d)}
  # Create cbz files for all sub dirs
    cbz_sub_dirs(main_dir)
  # new line
    puts
  end
