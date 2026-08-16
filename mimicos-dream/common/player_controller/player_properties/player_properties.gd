class_name PlayerProperties extends Resource

@export_range(2, 20, 1, "prefer_slider") var speed: float = 6.0:
	set(value):
		if value == speed:
			return
		speed = value
		on_properties_changed.emit()

@export_range(2, 4, 1, "prefer_slider") var dash_speed: float = 2.0:
	set(value):
		if value == dash_speed:
			return
		dash_speed = value
		on_properties_changed.emit()

@export_range(6, 20, 1, "prefer_slider") var jump: float = 8.0:
	set(value):
		if value == jump:
			return
		jump = value
		on_properties_changed.emit()

@export_range(1, 10, 1, "prefer_slider") var strength: float = 1.0:
	set(value):
		if value == strength:
			return
		strength = value
		on_properties_changed.emit()

@export_range(0, 10, 1, "prefer_slider") var knockback_timeout: float = 0:
	set(value):
		if value == knockback_timeout:
			return
		knockback_timeout = value
		on_properties_changed.emit()

signal on_properties_changed()
