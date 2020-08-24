extends Node

const path = "user://score.json"
var Error = load("res://ErrorHandler/Error.gd").new()

func createFile():
	var f = File.new()
	if not f.file_exists(path):
		f.open(path, File.WRITE)
		var def_data = {"high_score":0}
		f.store_string(JSON.print(def_data))
		f.close()
	else:
		f.open(path, File.READ)
		var data = f.get_as_text()
		data = JSON.parse(data)
		if data.error != OK:
			print(data.error)
			f.close()
			var d = Directory.new()
			d.remove(path)
			return createFile()
	return 0

func getScore() -> int:
	var f = File.new()
	f.open(path, File.READ)
	var data = JSON.parse(f.get_as_text())
	if data.error != OK:
		return createFile()
	return int(data.result["high_score"])

func setScore(score:int) -> void:
	var f = File.new()
	f.open(path, File.WRITE)
	var data = {"high_score":score}
	f.store_string(JSON.print(data))
	f.close()
