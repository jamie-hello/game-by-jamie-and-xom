extends Control

var player1nametag = preload("res://img/toplayer1.png")
var player2nametag = preload("res://img/toplayer2.png")
var player3nametag = preload("res://img/toplayer3.png")
var player1rack = preload("res://img/player1dealzone.png")
var player2rack = preload("res://img/player2dealzone.png")
var player3rack = preload("res://img/player3dealzone.png")
@onready var player1 = $"DealZone Player1"
@onready var player2 = $"DealZone Player2"
@onready var player3 = $"DealZone Player3"

# Called when the node enters the scene tree for the first time.
func _ready():
	player1.get_node("NameTag").set_texture(player1nametag)
	player2.get_node("NameTag").set_texture(player2nametag)
	player3.get_node("NameTag").set_texture(player3nametag)
	
	player1.get_node("Rack").set_texture(player1rack)
	player2.get_node("Rack").set_texture(player2rack)
	player3.get_node("Rack").set_texture(player3rack)
	
	player1.get_node("Rack").set_light_mask(2)
	player2.get_node("Rack").set_light_mask(4)
	player3.get_node("Rack").set_light_mask(8)
	
	player1.get_node("PointLight2D").set_item_cull_mask(2)
	player2.get_node("PointLight2D").set_item_cull_mask(4)
	player3.get_node("PointLight2D").set_item_cull_mask(8)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
