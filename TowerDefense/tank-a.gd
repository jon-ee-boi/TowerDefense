
extends RigidBody2D

var global

# Speed of the unit in pixel/sec
var speed = 40

# Number of hit points
var health = 50

# Number of Armor points
var armor = 2

# Number of damage points done by the unit when it reaches its goal
var damage = 1

# Number of coins gained when the unit is destroyed
var reward = 5

# Number of seconds since the unit died
var dead_since = 0


func _ready():
	add_to_group("enemy")
	global = get_node("/root/global")
	set_fixed_process(true)

func _fixed_process(delta):
	if health <= 0:
		if dead_since > global.DEAD_CLEAN_INTVAL:
			queue_free()
		else:
			dead_since += delta
		return

	if get_parent().get_unit_offset() < 1.0:
		get_parent().set_offset(get_parent().get_offset() + (speed * delta) )
	else:
		print(get_name() + " reached the fortress")
		global.health -= damage
		queue_free()

func hit(damage):
	health -= max(0, damage - armor)
	if health <= 0:
		print(get_name(), " destroyed!")
		# Add wreckage
		var scene = preload("res://wreck-a.scn")
		var wreck = scene.instance()
		wreck.set_pos(get_global_pos())
		var root = get_node("/root")
		global.current_level.add_child(wreck)
		global.current_level.move_child(wreck, 0)
		
		var texture = ImageTexture.new()
		texture.load("res://assets/images/tank-a-dead.png")
		var sprite = get_node("Sprite")
		sprite.set_texture(texture)
		sprite.set_hframes(1)
		sprite.set_frame(0)
		remove_from_group("enemy")
		global.cash += reward

