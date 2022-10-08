extends EntityFactory
class_name StageEntityFactory

const STAGE_ENTITY_CAPACITY := 100
const STAGE_ENTITY_PADDING := 200

func _on_ready() -> void:
	Global.stage_entity_factory = self
	entity = preload("res://Objects/StageEntity.tscn")
	entity_capacity = STAGE_ENTITY_CAPACITY
	entity_padding = STAGE_ENTITY_PADDING

func spawn(posn, init_angle, init_speed, init_type, init_health, init_resist, init_behaviour = null) -> StageEntity:
	var b = get_entity()
	if b: b.init_entity(posn, wrapf(init_angle, 0, 2*PI), init_speed, init_type, init_health, init_resist, init_behaviour)
	return b

func get_closest_to_point(posn : Vector2) -> StageEntity:
	var cur_closest = null
	var cur_dist_squared = -1
	for obj in get_children():
		if !obj.freed:
			var next_dist_squared = obj.position.distance_squared_to(posn)
			if cur_closest == null:
				cur_closest = obj
				cur_dist_squared = next_dist_squared
			elif next_dist_squared < cur_dist_squared:
				cur_closest = obj
				cur_dist_squared = next_dist_squared
	return cur_closest

func clear_active() -> void:
	for obj in get_children():
		if !obj.freed && !obj.is_queued_for_despawn:
			obj.die(StageEntity.DEATH_TYPE.EXPLODE_EMPTY)
