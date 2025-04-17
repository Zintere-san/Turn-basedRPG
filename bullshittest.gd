extends Node2D

func bullshit_test(value, second):
	print("BULLSHIT TEST CALLED WITH:", value)


func _ready():
	var anim = $AnimationPlayer.get_animation("TestAnim")

	for track_idx in range(anim.get_track_count()):
		if anim.track_get_type(track_idx) != Animation.TYPE_METHOD:
			continue

		for key_idx in range(anim.track_get_key_count(track_idx)):
			var key_val = anim.track_get_key_value(track_idx, key_idx)
			if typeof(key_val) == TYPE_DICTIONARY and key_val.method == "bullshit_test":
				print("BEFORE:", key_val.args)

				# Change first and/or second parameter
				key_val.args[0] = "HELLO"  # first argument
				key_val.args[1] = 12345    # second argument

				anim.track_set_key_value(track_idx, key_idx, key_val)
				print("AFTER:", key_val.args)
