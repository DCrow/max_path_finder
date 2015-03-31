class Node

	# Конструктор. Принимает массив данных. Количество столбцов в таблице данных
	# из которой сделан массив. И начальную вершину первой строки.
	def initialize(data_array, num_cools)
		@data_hash = Hash[makeNumberArray(data_array.length - 1).zip(data_array)]
		@num_cools = num_cools
		@nodeSum = data_array[0]
		@curr_node = 0
		@start_node = 0
		@nodeStack = Array.new
		@nodePath = Array.new
		@nodePath.push 0
		@wentBack = false
	end

private
	@start_node # Значение первоначальной вершины в древе
	@data_hash # Для хранения значений
	@num_cools = 0 # Хранение значений столбцов в таблице
	@nodeSum = 0 # Сумма вершин предшествующих нынешней с учетом нынешней
	@@maxNodeSum = 0 # Максимальная сумма вершин. Для удобства одна на все древа.
	@curr_node = 0 # Вершина в которой мы находимся
	@@nodeMaxPath = Array.new # Путь максимальной суммы вершин @@maxNodeSum. Для удобства одна на все древа.
 	@nodePath = Array.new # Путь который мы использовали чтобы попасть в @curr_node
	@nodeStack = Array.new # Вершины от которых мы еще не посетили второй соседней вершины
	@wentBack = false # Для знания вернулись ли в вершину из которой не посетили второго соседа или нет.
	@pathEnd = false

	# Вспомогательный массив чисел от 0 до n для создания хеша данных
	def makeNumberArray(n)
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
			@nodeStack.push @curr_node
		end

		@curr_node += n
		@nodeSum += @data_hash[@curr_node]
		@nodePath.push @curr_node
		@wentBack = false
	end

	# Обновляет все переменные для прохода следующего древа с новым рутом
	def renew(n)
		@start_node += n
		@curr_node = @start_node
		@nodeSum = @data_hash[@start_node]
		@nodeStack = Array.new
		@nodePath = Array.new
		@nodePath.push @start_node
		@wentBack = false
		@pathEnd = false
	end

 	# Вернуться в вершину от которой мы не посещали вторую соседнюю вершину
	def go_back()
		if !@nodeStack.empty?

			@wentBack = true
			back_node = @nodeStack.pop
			
			i_r = (@curr_node - back_node - 1)/@num_cools - 1
			i_l = (@curr_node - back_node)/@num_cools - 1

			if (i_r.is_a? Integer) && i_r != 0 && i_r > 0
				(0..i_r).each do |x|
					b_nod = @nodePath.pop
					@nodeSum -= @data_hash[b_nod]
				end
			elsif (i_l.is_a? Integer) && i_l != 0 && i_l > 0
				(0..i_l).each do |x|
					b_nod = @nodePath.pop
					@nodeSum -= @data_hash[b_nod]
				end
			else
				b_nod = @nodePath.pop
				@nodeSum -= @data_hash[@curr_node]
			end

			@curr_node = back_node
		else

			@pathEnd = true
		end
	end

	# Проверить не является ли сумма на ныншнем пути наибольшей
	def checkMaxSum()

		maxSum = [@nodeSum,@@maxNodeSum].max

		if maxSum == @nodeSum
			(0..@@nodeMaxPath.length).each do |i|
				@@nodeMaxPath.pop
			end
			(1..@nodePath.length).each do |i|
				@@nodeMaxPath.push @nodePath[i-1]
			end

			@@maxNodeSum = maxSum
		end
	end

public

	# Поиск пути наибольшей суммы
	def findMaxSumPath()

		left = @num_cools
		right = @num_cools + 1

		(1..@num_cools-@start_node).each do |i|
			begin

				if (check_forward(left) && (@wentBack == false))
					go(left)
				elsif check_forward(right)
					go(right)	
				else
					checkMaxSum()
					go_back()
				end
			end while !@pathEnd

			renew(1)
		end
	end

	# Возвращает путь максимальной суммы
	def getNodeMaxPath()
		return @@nodeMaxPath
	end

	# Возвращает максимальную сумму
	def getNodeMaxSum()
		return @@maxNodeSum
	end

end
