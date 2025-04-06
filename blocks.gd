extends TileMapLayer

func headbutt(global_collision_position: Vector2):
	var local_coords = Vector2i(to_local(global_collision_position))
	var cell_coords = local_to_map(local_coords)+Vector2i.UP
	var source_id = get_cell_source_id(cell_coords)
	var alternative_tile = get_cell_alternative_tile(cell_coords)
	var atlas_coords = get_cell_atlas_coords(cell_coords)
	var tile_data = get_cell_tile_data(cell_coords)

	if atlas_coords == Vector2i(5,7):
		var contents = tile_data.get_custom_data("contents")
		print(contents)
		if contents == "coin":
			tile_data.set_custom_data("contents", "")
			visible = false
			$"../QBumpUp".position = to_global(map_to_local(cell_coords))
			$"../AnimationPlayer".play("bump_up")
			var timer = Timer.new()
			timer.wait_time = 1
			timer.autostart
			await timer.timeout
			set_cell(cell_coords, source_id, Vector2i(8,7), alternative_tile)
			visible = true
