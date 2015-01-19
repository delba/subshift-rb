require 'tempfile'

class File
  def self.copylines(src, dst)
    tempfile = Tempfile.new(dst)

    begin
      readlines(src).each do |line|
        line = yield(line) if block_given?

        tempfile.write line
      end

      FileUtils.chmod(stat(src).mode, tempfile.path)
      FileUtils.move(tempfile.path, dst)
    ensure
      tempfile.close!
    end
  end
end
