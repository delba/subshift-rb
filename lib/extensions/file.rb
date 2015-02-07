require 'tempfile'

module Extensions
  module File
    def copylines(src, dst)
      tempfile = Tempfile.new(dst)

      begin
        open(src).each_line do |line|
          if block_given?
            new_line = yield(line)
            line = new_line unless new_line.nil?
          end

          tempfile.write line
        end

        FileUtils.chmod(stat(src).mode, tempfile.path)
        FileUtils.move(tempfile.path, dst)
      ensure
        tempfile.close!
      end
    end
  end
end

File.singleton_class.prepend Extensions::File
