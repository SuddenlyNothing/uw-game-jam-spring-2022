class_name EnemyMove
extends EnemyKnockback

export(int) var move_speed := 50

var move_dir
var face_pos

### Anims needed:
### idle
### death
### knockback
### move +


func move() -> void:
	move_and_slide(move_speed * move_dir)
	set_facing(face_pos)
