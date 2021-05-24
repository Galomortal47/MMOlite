extends Timer
class_name ClassTimer

var hours = 0
var mins = 0
var secs = 0
var days = 0
var total = ""
var time = 0

func int_to_time(var integer, var dict = {"secs" : true,"mins" : true,"hours" : false,"days" : false, "24hrs": false  }):
	secs = integer
	print(secs)
	if secs >= 60:
		mins += int(secs/59)
		secs = fmod(secs, 60)
	if mins >= 60:
		hours += int(mins/59)
		mins = fmod(mins, 60)
	if hours >= 24 and dict["24hrs"]:
		days += int(hours/23)
		hours = fmod(hours, 24)
	var date = ""
	if dict["days"]:
		date += conver_str(days)
	if dict["hours"]:
		if dict["days"]:
			date += ":"
		date += conver_str(hours)
	if dict["mins"]:
#		date += ":"
		date += conver_str(mins)
	if dict["secs"]:
		date += ":"
		date += conver_str(secs)
	return date

func conver_str(var num):
	if num == 0:
		return "00"
	if num < 10:
		return "0"+ str(int(num))
	else:
		return str(int(num))
