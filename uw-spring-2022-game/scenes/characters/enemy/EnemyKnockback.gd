class_name EnemyKnockback
extends Enemy

export(int) var knockback_force := 500
export(int) var knockback_friction := 2000

# if damage is greater than 1, knockback force is multiplied by (damage - 1) * knockback_modifier + 1
export(float) var knockback_modifier := 0.3

var knockback_velocity := Vector2()

### Anims needed:
### idle
### death
### knockback +


func hit(damage: int, dir: Vector2) -> void:
	if health <= 0:
		return
	knockback_velocity = ((damage - 1) * knockback_modifier + 1) * knockback_force * dir
	.hit(damage, dir)


func knockback(delta: float) -> void:
	move_and_slide(knockback_velocity)
	var friction_amount := knockback_friction * delta
	if knockback_velocity.length() <= friction_amount:
		knockback_velocity = Vector2()
	else:
		knockback_velocity -= friction_amount * knockback_velocity.normalized()
