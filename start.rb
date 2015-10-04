require 'json'
require 'csv'

INPUT_DIR = "./storage/json"
OUTPUT_DIR = "./storage/csv"

JLAC10_CODES = [
  "9N011000000000001",
  "9N016160100000001",
  "1A010000000190111",
  "1A020000000190111",
  "9A751000000000001",
  "9A761000000000001",
  "9A752000000000001",
  "9A762000000000001",
  "9A755000000000001",
  "9A765000000000001",
  "2A020000001930101",
  "2A030000001930101",
  "3F070000002327101",
  "3F077000002327101",
  "3F015000002327101",
  "3B035000002327201",
  "3B045000002327201",
  "3B090000002327101",
  "3D010000001926101",
  "2A040000001930102",
  "3D045000001906202",
  "3D046000001906202",
  "9N701000000000011",
  "9N706000000000011",
  "9N711000000000011",
  "9N736000000000011",
  "9N746000000000011",
  "9N751000000000011",
  "9N756000000000011",
  "9N766000000000011",
  "9N771000000000011",
  "9N776000000000011",
  "9N781000000000011",
  "9N786000000000011",
  "9N791000000000011",
  "9N796000000000011",
]

# CSVにするArray
details_ary = []

# Arrayにヘッダデータを格納する
headers = []
headers << 'userkey'
headers << 'kenshinbi'
headers << 'nenrei'
headers << 'seibetu'
JLAC10_CODES.each {|jlac10_code|
  headers << jlac10_code
}

details_ary << headers

# ArrayにJSONのデータを格納する
Dir.foreach(INPUT_DIR) { |file_name|
  if file_name[-5, 5] == ".json"
    scores_input_json = File.read("#{INPUT_DIR}/#{file_name}")
    raw = JSON.parse(scores_input_json, quirks_mode: true)
    data = raw['data']
    user_key = data['userkey']
    examination_headers = data['detail']

    examination_headers.each {|examination_header|
      tmp = []
      examination_details = examination_header['detail']

      tmp << user_key
      tmp << examination_header['kenshinbi']
      tmp << examination_header['nenrei']
      tmp << examination_header['seibetu']

      JLAC10_CODES.each {|jlac10_code|
        is_found = false
        examination_details.each {|hash|
          if hash['jlac10Cd'] == jlac10_code
            tmp << hash['value']
            is_found = true
          end
        }
        if is_found == false
          tmp << ""
        end
      }

      details_ary << tmp
    }
  end
}

# 配列をCSVに書き出す
CSV.open("#{OUTPUT_DIR}/ca_scores_#{DateTime.now.strftime("%Y%m%d_%H%M%S")}.csv", "wb") {|line|
  details_ary.each {|record|
    line << record
  }
}
