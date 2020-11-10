module JuliTask

import JSON
using Dates

export colnames, tasktable

colspecs = Dict{String, DataType}()
for line in readlines(`task columns`)
	result = match(r"([[:alnum:]]+)( +)([[:alnum:]]+)", line)
	if typeof(result) == Nothing
		continue
	elseif result.captures[3] in ["string", "date", "numeric"]
		if result.captures[3] == "string"
			push!(colspecs, result.captures[1] => String)
		elseif result.captures[3] == "date"
			push!(colspecs, result.captures[1] => DateTime)
		else
			push!(colspecs, result.captures[1] => Float64)
		end
	end
end

function colnames()
	collect(keys(colspecs))
end

tasknames = colnames()
 
function taskDateTime(dateString)
	if ismissing(dateString)
		return missing
	end
	year = parse(Int, dateString[1:4])
	month = parse(Int, dateString[5:6])
	day = parse(Int, dateString[7:8])
	hour = parse(Int, dateString[10:11])
	minute = parse(Int, dateString[12:13])
	second = parse(Int, dateString[14:15])
	DateTime(year, month, day, hour, minute, second)
end

tasks = JSON.parse(read(`task export`, String))

"""
    tasktable(x = colnames())

Return a table (as a Dictionary) of Taskwarrior 
"""
function tasktable(colnames::Array{String, 1} = colnames())
	columns = Dict{String, Array}()
	for colname in colnames
		println(colname)
		coltype = get(colspecs, colname, String)
		if colname == "tags"
			coltype = Array{String, 1}
		end
		column = Union{coltype, Missing}[]
		for task in tasks
			value = get(task, colname, missing)
			if coltype == DateTime
				value = taskDateTime(value)
			end
			push!(column, value)
		end
		push!(columns, colname => column)
	end
	columns
end

end # module
