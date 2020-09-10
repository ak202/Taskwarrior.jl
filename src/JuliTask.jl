module JuliTask

import JSON
using Dates

export task_columns, task_table, tasks

struct tw_column
	name::String
	type::DataType
end

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

task_columns = function()
	twColumns = tw_column[]
	for line in readlines(`task columns`)
		result = match(r"([[:alnum:]]+)( +)([[:alnum:]]+)", line)
		if typeof(result) == Nothing
			continue
		elseif result.captures[3] in ["string", "date", "numeric"]
			if result.captures[3] == "string"
				push!(twColumns, tw_column(result.captures[1], String))
			elseif result.captures[3] == "date"
				push!(twColumns, tw_column(result.captures[1], DateTime))
			else
				push!(twColumns, tw_column(result.captures[1], Float64))
			end
		end
	end
	return twColumns
end

function task_columns_old()
	colnames = String[]
	for task in tasks for key in keys(task)
			if !(key in colnames)
				push!(colnames, key)
			end
		end
	end
	return colnames
end

struct TWTask
	uuid::String
	entry::Union{DateTime, Missing}
	scheduled::Union{DateTime, Missing}
	wait::Union{DateTime, Missing}
	due::Union{DateTime, Missing}
	until::Union{DateTime, Missing}
	termination::Union{DateTime, Missing}
end

function task_table()
	twtasks = TWTask[]
	for task in tasks
		uuid = get(task, "uuid", missing)
		entry = get(task, "entry", missing) |> taskDateTime
		scheduled = get(task, "scheduled", missing) |> taskDateTime
		wait = get(task, "wait", missing) |> taskDateTime
		due = get(task, "due", missing) |> taskDateTime
		until = get(task, "until", missing) |> taskDateTime
		termination = get(task, "termination", missing) |> taskDateTime
		push!(twtasks, TWTask(uuid, entry, scheduled, wait, due, until, termination))
	end
	return twtasks
end


end # module
