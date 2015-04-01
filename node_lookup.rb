class Node

	# Конструктор. Принимает массив данных. Количество столбцов в таблице данных
	# из которой сделан массив. И начальную вершину первой строки.
	def initialize(data_array, num_cools)
		@data_hash = Hash[make_num_array(data_array.length - 1).zip(data_array)]
		@num_cools = num_cools
		@node_sum = data_array[0]
		@curr_node = 0
		@start_node = 0
		@node_stack = Array.new
		@node_path = Array.new
		@node_path.push 0
		@went_back = false
	end

private
	@start_node # Значение первоначальной вершины в древе
	@data_hash # Для хранения значений
	@num_cools = 0 # Хранение значений столбцов в таблице
	@node_sum = 0 # Сумма вершин предшествующих нынешней с учетом нынешней
	@@node_max_sum = 0 # Максимальная сумма вершин. Для удобства одна на все древа.
	@curr_node = 0 # Вершина в которой мы находимся
	@@node_max_path = Array.new # Путь максимальной суммы вершин @@node_max_sum. Для удобства одна на все древа.
 	@node_path = Array.new # Путь который мы использовали чтобы попасть в @curr_node
	@node_stack = Array.new # Вершины от которых мы еще не посетили второй соседней вершины
	@went_back = false # Для знания вернулись ли в вершину из которой не посетили второго соседа или нет.
	@path_end = false
	# Вспомогательный массив чисел от 0 до n для создания хеша данных
	def make_num_array(n)
		num_arr = Array.new
		(0..n).each do |k|
			num_arr[k] = k
		end
		return num_arr
	end

	# Проверить есть ли соседняя вершина
	def check_forward(n)
		c = @curr_node + n

			if @data_hash.has_key?(c) && (n - @start_node - 2 != 0)
				return true
			else
				return false
			end
	end

	# Переход из вершины в соседнюю вершину
	def go(n)

		if n == @num_cools && check_forward(@num_cools + 1)
			@node_stack.push @curr_node
		end

		@curr_node += n
		@node_sum += @data_hash[@curr_node]
		@node_path.push @curr_node
		@went_back = false
	end

	# Обновляет все переменные для прохода следующего древа с новым рутом
	def renew(n)
		@start_node += n
		@curr_node = @start_node
		@node_sum = @data_hash[@start_node]
		@node_stack = Array.new
		@node_path = Array.new
		@node_path.push @start_node
		@went_back = false
		@path_end = false
	end

 	# Вернуться в вершину от которой мы не посещали вторую соседнюю вершину
	def go_back()
		if !@node_stack.empty?

			@went_back = true
			back_node = @node_stack.pop
			
			i_r = (@curr_node - back_node - 1)/@num_cools - 1
			i_l = (@curr_node - back_node)/@num_cools - 1

			if (i_r.is_a? Integer) && i_r != 0 && i_r > 0
				(0..i_r).each do |x|
					b_nod = @node_path.pop
					@node_sum -= @data_hash[b_nod]
				end
			elsif (i_l.is_a? Integer) && i_l != 0 && i_l > 0
				(0..i_l).each do |x|
					b_nod = @node_path.pop
					@node_sum -= @data_hash[b_nod]
				end
			else
				b_nod = @node_path.pop
				@node_sum -= @data_hash[@curr_node]
			end

			@curr_node = back_node
		else

			@path_end = true
		end
	end

	# Проверить не является ли сумма на ныншнем пути наибольшей
	def check_max_sum()

		max_sum = [@node_sum,@@node_max_sum].max

		if max_sum == @node_sum
			(0..@@node_max_path.length).each do |i|
				@@node_max_path.pop
			end
			(1..@node_path.length).each do |i|
				@@node_max_path.push @node_path[i-1]
			end

			@@node_max_sum = max_sum
		end
	end

public

	# Поиск пути наибольшей суммы
	def find_max_sum_path()

		left = @num_cools
		right = @num_cools + 1

		(1..@num_cools-@start_node).each do |i|
			begin

				if (check_forward(left) && (@went_back == false))
					go(left)
				elsif check_forward(right)
					go(right)	
				else
					check_max_sum()
					go_back()
				end
			end while !@path_end

			renew(1)
		end
	end

	# Возвращает путь максимальной суммы
	def get_node_max_path()
		return @@node_max_path
	end

	# Возвращает максимальную сумму
	def get_node_max_sum()
		return @@node_max_sum
	end

end
