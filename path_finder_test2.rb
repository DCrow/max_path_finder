require_relative "path_finder.rb"
require_relative "method_tester.rb"
require_relative "node_lookup.rb"

def delete_file(file_name)
	File.delete(file_name)
end

test_start(1)
#delete_file("text.txt")
f1 = DataChanger.new("test_file3.txt")
#puts f1.parse_data_array()
#puts f1.getNumOfCollumns()
data_ar = f1.parse_data_array()
col_num = f1.get_num_cools()
n1 = Node.new(data_ar, col_num)
n1.find_max_sum_path()
puts n1.get_node_max_path()
f1.write_file("test_file3_out.txt", n1.get_node_max_path())

test_end(1)