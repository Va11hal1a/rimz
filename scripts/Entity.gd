extends KinematicBody2D
class_name Entity

export var maxHealth = 100.0
onready var health = maxHealth

export var defaultSpeed = 10.0
onready var speed = defaultSpeed

var use setget setUse


func setUse(val):
	if $Use.get_child_count() != 0:
		$Use.get_child(0).queue_free()
	use = val.instance.instance()
	$Use.add_child(use)


var direction = Vector2()

#state machine
var curState: State setget setState
var nextState: State


class State:
	var entity

	func init(entity: Entity):
		self.entity = entity

	func start():
		print("state begin")

	func update():
		pass

	func end():
		print("state end")


class RoamState:
	extends State
	enum roamPath { default }
	var roam = false
	var roamDelay = 2.0
	var roamDelayAfter = 2.0
	var _roamPath = roamPath.default
	var active = true
	static func getRandomDir() -> Vector2:
		return Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()

	func start():
		while active:
			entity.direction = getRandomDir()
			yield(entity.get_tree().create_timer(roamDelay), "timeout")
			if ! active:
				return
			yield(entity.get_tree().create_timer(roamDelayAfter), "timeout")

	func end():
		active = false


class TargetFollowing:
	extends State
	var target: KinematicBody2D

	func update():
		entity.direction = (target.position - entity.position).normalized()


func stateControl():
	if curState:
		curState.update()


func setState(state: State):
	if curState == state:
		return
	if curState != null:
		curState.end()
	curState = state
	curState.start()


#effects
func applyEffects(effects: Dictionary):
	for effect in effects:
		call(effect, effects[effect])


func dmg(val):
	health -= val
	$Player.play("hit")


#base
func _ready():
	add_to_group("entity")


func _process(delta):
	stateControl()
	move_and_slide(direction * speed)
	if direction != Vector2():
		rotation = direction.angle()
