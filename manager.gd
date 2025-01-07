extends Node2D

var step = -1
var step_not_ran = false

var boom = false

var truck_pos = 0

func _draw():
	if $obrien.picked_up_water_gun:
		draw_line($obrien.position + Vector2(120, 35), Vector2(1520, -200), Color.BLACK, 10.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$vietnam_background.play()
	queue_redraw()

	if Input.is_action_just_pressed("next_step"):
		step += 1
		step_not_ran = true
	
	var phase_2_offset = 5
	
	if step_not_ran:

		if step == 0:
			$obrien_target.position.x = 2100
			$weisler.speed = 300
			$weisler_target.position.x = 1300
		
		elif step == 1:
			$obrien_target.position.x = $weisler.position.x + 150
			$weisler.speed = 400
			$weisler_target.position.x = 400
			$obrien.pick_up_water_gun()
			$obrien.speed = 900
			if $obrien.reached_position:
				$weisler.knockback()
				$weisler_health_bar.step()
				$obrien_target.position.x = 1520
				$obrien.drop_water_gun()
				$obrien.speed = 400
				step_not_ran = false
		
		elif step == 2:
			$weisler_target.position.x = 1250
			$weisler.letter_out()
			if $weisler.reached_position and not $obrien.cried_once:
				$obrien.cry()
			if not $obrien.crying and $obrien.cried_once:
				$weisler.letter_in()
				$weisler_target.position.x = 400
				$obrien.knockback()
				$obrien_health_bar.step()
				step_not_ran = false

		elif step == 3:
			$obrien.holding_grenade = true
			step_not_ran = false
		
		elif step == 4:
			$obrien.throw_grenade()
			if $obrien.done_throwing_grenade and boom == false:
				$boom.show()
				$weisler.knockback()
				$weisler_health_bar.step()
				boom = true
			if not $weisler.is_knocked_back and boom:
				$boom.hide()
				step_not_ran = false


		elif step == 0 + phase_2_offset:
			$weisler_target.position.x = 400 + 1920
			$obrien_target.position.x = 1520 + 1920
			if $weisler.reached_position and $weisler.position.x > 1920:
				$berlin_background.show()
				$vietnam_background.hide()
				$weisler.position.x = 400 - 1920
				$obrien.position.x = 1520 - 1920
				$weisler_target.position.x = 400
				$obrien_target.position.x = 1520
				step_not_ran = false

		elif step == 1 + phase_2_offset:
			$obrien.get_on_chair()
			$weisler.get_on_chair()
			$obrien_target.position.x = 1460
			$weisler_target.position.x = 560
			$table_target.position.y = 830
			step_not_ran = false
		
		elif step == 2 + phase_2_offset:
			$obrien.get_off_chair()
			$weisler.get_off_chair()
			$obrien_health_bar.step()
			$obrien.knockback()
			$obrien_target.position.x = 1520
			$weisler_target.position.x = 400
			$table_target.position.y = 1100
			step_not_ran = false

		elif step == 3 + phase_2_offset:
			$weisler.auto_anim_active = false
			$weisler.headphones()
			step_not_ran = false

		elif step == 4 + phase_2_offset:
			$weisler.cry()
			if $weisler.done_crying:
				$weisler.auto_anim_active = true
				$weisler_health_bar.step()
				$weisler.knockback()
				$weisler.show()
				step_not_ran = false
		
		elif step == 5 + phase_2_offset:
			if $truck.reached_position:
				if truck_pos == 0:
					$truck_target.position.x = 1520
					truck_pos += 1
				elif truck_pos == 1:
					$truck.start_soldier_move_timer()
					if not $truck.soldiers_moving:
						$ussr_soldier.show()
						$ussr_soldier2.show()
						$truck.start_stop_timer()
						if not $truck.stopped:
							$obrien.hide()
							$ussr_soldier.hide()
							$ussr_soldier2.hide()
							$truck.start_soldier_move_timer_2()
							if not $truck.soldiers_moving_2:
								$truck_target.position.x = 3000
								truck_pos += 1
	
				elif truck_pos == 2:
					$obrien_health_bar.step()
					$weisler.is_dancing = true
					step_not_ran = false
