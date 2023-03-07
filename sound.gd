extends Node

## Music & sound effect player and manager

func play_sfx(sfx):
	if Global.play_sfx:
		if sfx != null and sfx.has_method("play"):
			sfx.play()
		else:
			print_debug("Failed to play sound effect %s, doesn't have play() method" % sfx)
