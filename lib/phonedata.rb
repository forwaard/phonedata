require 'singleton'
require 'phonedata/version'

module Phonedata
  class Error < StandardError; end

  def self.find(phone_num)
    Pd.instance.find(phone_num)
  end

  def self.find_from_cli(phone_num)
    result = find(phone_num)
    result.to_s
  end

  def self.file_version
    Pd.instance.file_version
  end

  def self.total_record
    Pd.instance.total_record
  end

  def self.first_record_offset
    Pd.instance.first_record_offset
  end

  INT_LEN = 4
  CHAR_LEN = 1
  HEAD_LENGTH = 8
  PHONE_INDEX_LENGTH = 9
  PHONE_DAT = 'phone.dat'

  DICT = %w[nil 中国移动 中国联通 中国电信 中国电信虚拟运营商 中国联通虚拟运营商 中国移动虚拟运营商 中国广电 广电虚拟运营商]

  Result = Struct.new(:phone, :province, :city, :zipcode, :areazone, :card_type) do
    def to_s
      "#{phone} #{province} #{city} #{zipcode} #{zipcode} #{areazone} #{card_type}"
    end
  end
  class Pd
    include ::Singleton

    def initialize(dat_file_path = nil)
      df = dat_file_path
      if df.nil?
        dir = ENV['PHONE_DATA_DIR'] || File.join(File.dirname(__FILE__), '../data')
        df = File.join("#{dir}/#{PHONE_DAT}")
      end
      f = File.open(df)
      @bytes_content = f.read.bytes
    end

    def find(phone_num)
      raise ArgumentError, ' illegal phone length ' if phone_num.size < 7 || phone_num.size > 11

      searched_phone = phone_num[0...7].to_i
      # binary search
      min = 0
      max = total_record
      while min <= max
        mid = (min + max) / 2
        current_offset = (first_record_offset + mid * PHONE_INDEX_LENGTH)
        break if current_offset >= _total_len

        record_offset_start_idx = current_offset + INT_LEN
        card_type_start_idx = current_offset + INT_LEN * 2
        cur_phone_seg = _get4(@bytes_content[current_offset...record_offset_start_idx])
        record_offset = _get4(@bytes_content[record_offset_start_idx...card_type_start_idx])
        card_type = @bytes_content[card_type_start_idx]
        if searched_phone > cur_phone_seg
          min = mid + 1
        elsif searched_phone < cur_phone_seg
          max = mid - 1
        else
          sub_arr = @bytes_content[record_offset...first_record_offset]
          full_data_arr = sub_arr[0...sub_arr.index(0)]
          full_data_str = full_data_arr.pack('C*').force_encoding('UTF-8')
          result = full_data_str.split('|')

          return Result.new(phone_num, result[0], result[1], result[2], result[3], DICT[card_type])
        end
      end
      Result.new(phone_num, nil, nil, nil, nil, nil)
    end

    def file_version
      @bytes_content[0...INT_LEN].pack('C*')
    end

    def first_record_offset
      arr = @bytes_content[INT_LEN...HEAD_LENGTH]
      _get4(arr)
    end

    def total_record
      (_total_len - first_record_offset) / PHONE_INDEX_LENGTH
    end

    private

    def _total_len
      @bytes_content.size
    end

    def _get4(byte_arr)
      if byte_arr.size < 4
        0
      else
        byte_arr[0] | byte_arr[1] << 8 | byte_arr[2] << 16 | byte_arr[3] << 24
      end
    end
  end
end
