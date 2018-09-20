
reactor = peripheral.wrap("BigReactors-Reactor_0")

genInfo = {"RF/t" = 0, "mB/t" = 0}
ctrlRodLvl = {}

for i=0, 90, 10 do
	ctrlRodLvl[i] = genInfo
end 

function initLog()
	if fs.exists("disk/reactorLog") then
		print('Log file Already Exists\n')
	else
		reactLog = fs.open("disk/reactorLog","w")
		reactLog.writeLine("--- Reactor Efficiency Log ---\n\n")
		reactLog.close()
		print("Log file created\n")
	end
end

function logShit(shit)
	reactLog = io.open("disk/reactorLog","a")
	reactLog:write("|	CR Level	|	RF/t	|	mB/t	|\n")
	reactLog:write("|---------------+-----------+-----------|\n")
	for lvl, info in ipairs(shit) do
		local level = textutils.serialize(lvl)
		local rft = textutils.serialize(shit[lvl]["RF/t"])
		local mbt = textutils.serialize(shit[lvl]["mB/t"])
		reactLog:write("|	"..level.."	|	"..rft.."	|	"..mbt.."	|\n") 
	end
	reactLog:write("|---------------+-----------+-----------|\n\n")
	reactLog.close()
end

initLog()
reactor.setActive(true)
print("Reactor started...\n")
reactor.setAllControlRodLevels(0)
print("Controls rod levels set to 0% insertion...\n")
print("Wait 10 seconds for reactor to warm up...\n")
sleep(10)
print("Reactor warmed. Beginning testing...\n")

while reactor.getActive() do
	-- local continue = true
	for lvl, info in pairs(ctrlRodLvl) do
		local count = 0
		reactor.setAllControlRodLevels(lvl)
		sleep(2)
		while count <= 50 do
			count = count+1
			rftSum = reactor.getEnergyProducedLastTick()
			mbtSum = reactor.getFuelConsumedLastTick()
		end
		ctrlRodLvl[lvl]["RF/t"] = rftSum/count
		ctrlRodLvl[lvl]["mB/t"] = mbtSum/Count
		print("Average Rf/t and mB/t calculated for "..textutils.serialize(lvl).."% control rod insertion.\n")
	end
	print("Average rf/t and mB/t calculated for all percentages for this coolant. Logging to file...\n")
	logShit(ctrlRodLvl)
	print("Logged to file.")
	print("\nShutting the reactor down...")
	reactor.setActive(false)
end
