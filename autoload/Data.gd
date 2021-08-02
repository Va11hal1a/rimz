extends Node
var path = "user://save.sf"
var content = ''
var data = {}
func _ready():
	var file = File.new()
	content = ''
	if(file.file_exists(path)):
		file.open(path, File.READ)
		content = file.get_as_text()
		for line in content.split('\n'):
			if(line == ''):continue
			data[line.split(' ')[0]] = line.split(' ')[1]
		file.close()
func _save():
	var file = File.new()
	file.open(path, File.WRITE)
	for key in data.keys():
		file.store_string(key + ' ' + data[key] + '\n')
	file.close()
func _clear():
	data.clear()
	_save()
func test():
	print(data)
	data['fallen'] = '1'
	_save()
