class_name Enemy
extends KinematicBody2D

export(int) var max_health: int = 3
export(String, FILE, "*.tscn") var death_particles

onready var DeathParticles: PackedScene = load(death_particles)
onready var health := max_health
onready var enemy_states := $EnemyStates
onready var pivot := $Pivot
onready var anim_sprite := $Pivot/AnimatedSprite
onready var hit_flash_tween := $HitFlashTween
onready var particle_position := $Pivot/ParticlePosition
onready var body_collision := $CollisionShape2D
onready var hurtbox_collision := $Pivot/Hurtbox/CollisionShape2D

### Anims needed:
### idle +
### death +

func hit(damage: int, dir: Vector2) -> void:
	if health <= 0:
		return
	if damage > health:
		enemy_states.call_deferred("set_state", "death")
	health -= damage
	hit_flash_tween.interpolate_property(pivot.get_material(), "shader_param/hit_strength",
			1, 0, 0.1)
	hit_flash_tween.start()


func die() -> void:
	var dp := DeathParticles.instance()
	dp.position = particle_position.global_position
	get_parent().add_child(dp)
	queue_free()


func set_facing(pos: Vector2) -> void:
	if (pos.x > position.x and pivot.scale.x < 0) or\
			(pos.x < position.x and pivot.scale.x > 0):
		pivot.scale.x *= -1


func play_anim(anim: String) -> void:
	if anim_sprite.animation == anim:
		return
	anim_sprite.play(anim)


func set_collision_disabled(val: bool) -> void:
	hurtbox_collision.call_deferred("set_disabled", val)
	body_collision.call_deferred("set_disabled", val)


func anim_finish() -> void:
	if anim_sprite.animation == "death":
		die()


func _on_AnimatedSprite_animation_finished() -> void:
	anim_finish()
