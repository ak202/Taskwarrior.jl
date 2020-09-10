
using Random

function task_table(cols)
	eval(typeGen("twTask", cols))
	println(fieldnames(twTask))
	twTasks = twTask[]
	for task in tasks
		args = String[]
		for col in cols
			push!(args, get(task, col, ""))
		end
		push!(twTasks, twTask(args...))
	end
	return twTasks
end

typeGen = function(name, fields)
	s3 = "mutable struct $name\n"
	for i in 1:length(fields)
		name = fields[i].name
		if name == "end"
			name = "ending"
		end
		add = "$(name)::$(fields[i].type)\n"
		println(add)
		s3 *= add
	end
	final = s3 * "end"
	return(final)
	return Meta.parse(final)
end

cols = task_columns()
cols[1]

eval(typeGen("test_s1", cols))
testcols = cols[[25, 1, 5, 7]]
testcols = cols[8:9]
test = typeGen("test_s3", cols)
test = typeGen("test_s3", testcols)
eval(Meta.parse(test))

part1 = "mutable struct testStruct2\n"
part2 = "one::String\n"
part3 = "four::String\n"
part4 = "three::String\n"
part5 = "end"

complete = part1*part2*part3*part4*part5
eval(Meta.parse(complete))

complete |> Meta.parse |> eval




for task in tasks
	push!(categories, get(task, "category", "none"))
	push!(baseValue, get(task, "baseValue", 0))
end

colnames = ["category", "baseValue"]


for task in tasks
	@addCol("category")
end

categories
baseValue

macro sayHello(name)
	return :( println("hello", $name) )
end

macro testMacro(input)
	:( mutable struct testStruct
		  a::String
		  $input::String
	  end )
end

macro m1()
#	println(typeof(input))
	a = 1 + 1
	return :($a)
end

macro m2(input)
	test = :($input)
#	test = 2
	return :( $test )
end

println(i) for i in 1:5
#	:( push!($name, get(task, "$name", "none")) )


t1 = (a = 1, b = 2)
t2 = (a = 3, b = 4)
DataFrame(t1, t2)


