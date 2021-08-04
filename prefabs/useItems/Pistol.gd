extends Sprite

export var bulletTexture: Texture
export var speed := 100.0
var inventory

func bulletCreate(dir: Vector2):
	var temp = RigidBody2D.new()
	temp.apply_impulse(Vector2(), dir*speed)
	temp.gravity_scale = 0.0
	temp.global_position = global_position

	var textureInstance = Sprite.new()
	textureInstance.texture = bulletTexture
	textureInstance.rotation = dir.angle() + PI*0.5
	temp.add_child(textureInstance)

	get_parent().get_parent().get_parent().add_child(temp)


var wait = false;
func do(dir: Vector2):
	global_rotation = dir.angle()
	if(wait): return;
	wait = true;
	bulletCreate(dir)
	yield(get_tree().create_timer(0.5),"timeout");
	wait = false;
