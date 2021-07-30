extends Node2D
onready var tween = $Tween
func fade_start(node, duration):
	if(!node.visible):node.visible=true
	node.modulate.a = 0.0
	tween.interpolate_property(node,'modulate:a', 0.0,1.0,duration, Tween.TRANS_CUBIC)
	tween.start()
	yield(tween,"tween_all_completed")
func fade_end(node, duration):
	node.modulate.a = 1.0
	tween.interpolate_property(node,'modulate:a', 1.0,0.0,duration, Tween.TRANS_CUBIC)
	tween.start()
	yield(tween,"tween_all_completed")
func move_to(node,position, duration):
	tween.interpolate_property(node,'position', node.position,position,duration, Tween.TRANS_CUBIC)
	tween.start()
	yield(tween,"tween_all_completed")
func lambda(function) ->Expression:
	var expression = Expression.new()
	var err_code = expression.parse(function,['x'])
	if(err_code != OK):
		print(expression.get_error_text())
	return expression
func map(expr,array):
	var lambda = lambda(expr)
	for i in range(0,len(array)):
		array[i]=lambda.execute([array[i]])
func filter(expr,array):
	var new = []
	var lambda = lambda(expr)
	for i in array:
		if(lambda.execute([i])):
			new.push_back(i)
	return new
func callFor(expr,array):
	var lambda = lambda(expr)
	for i in array:
		lambda.execute([i])
