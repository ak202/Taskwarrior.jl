import JSON
using DataFrames
using Dates
using Plots
gr()

function calcPoints(scheduled, finished, due, baseValue, decayType)
	points = 0.0
	if ismissing(scheduled) | ismissing(finished) | ismissing(due) | ismissing(baseValue) | ismissing(decayType)
		return points
	end
	if decayType == "linear"
		remainingTime = due - finished
		remainingTime = Dates.value(remainingTime)
		totalTime = due - scheduled
		totalTime = Dates.value(totalTime)
		rewardFraction = remainingTime/totalTime
		points = baseValue * rewardFraction
	elseif decayType == "binary"
		points = baseValue
	end
end

# reinitialize chartDF
dates = Date(2020,6,1):Dates.Day(1):Dates.today()
chartDF = DataFrame(date = Date[], routine = Float32[], education = Float32[], fitness = Float32[], reminder = Float32[])
for i in 1:length(dates)
	date = dates[i]
	initialPoints = 0
	push!(chartDF, (date, initialPoints, initialPoints, initialPoints, initialPoints))
end

try
	run(`task sync`)
catch
	println("moar internets")
end

colnames()
test = ["description", "entry", "baseValue"]
table = DataFrame(tasktable(test))

testtable = DataFrame(tasktable(["tags"]))
testarray = collect(skipmissing(testtable[:1]))
testarray[819]
