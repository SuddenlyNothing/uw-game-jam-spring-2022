class_name EnemyShoot
extends EnemyStrafe

export(int) var attack_frame := 0
export(String, FILE, "*.tscn") var projectile := ""
export(float) var min_shot_delay := 0.5
export(float) var max_shot_delay := 4

var projectile_dir := Vector2()

onready var Projectile: PackedScene = load(projectile)
onready var projectil_position := $Pivot/ProjectilePosition
onready var shot_delay_timer := $ShotDelayTimer

### Anims needed:
### idle
### death
### knockback
### move
### attack +


func set_projectile_dir() -> void:
	projectile_dir = position.direction_to(player.position)


func start_shot_delay() -> void:
	shot_delay_timer.start(lerp(min_shot_delay, max_shot_delay, randf()))


func attack() -> void:
	var p := Projectile.instance()
	p.position = projectil_position.global_position
	p.dir = projectile_dir
	get_parent().add_child(p)


func _on_AnimatedSprite_animation_finished() -> void:
	if anim_sprite.animation == "attack":
		enemy_states.call_deferred("set_state", "idle")
	._on_AnimatedSprite_animation_finished()


func _on_AnimatedSprite_frame_changed() -> void:
	if anim_sprite.animation == "attack":
		match anim_sprite.frame:
			attack_frame:
				attack()
