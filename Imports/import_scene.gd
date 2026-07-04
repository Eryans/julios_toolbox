@tool
extends EditorScenePostImport

var default_mat: StandardMaterial3D = load("uid://dje15mle3klcb")
var metallic_mat: StandardMaterial3D = load("uid://cto3lacvd2tyc")
var blockout_mat: ShaderMaterial = load("uid://ke2h255hvsvr")

var scene_dictionnary: Dictionary[String, PackedScene] = {
	"player" = load("uid://dfebn8reooexy"),
	"crate" = load("uid://ch1frl4htoix0")
}

var root: Node

func _post_import(scene):
	root = scene
	iterate(scene)
	return scene

func iterate(node) -> void:
	if !node:
		return
	var node_name: String = node.name.to_lower()
	var splitted_name: PackedStringArray = node_name.split("_")
	var trimmed_name: String = splitted_name[0]
	if splitted_name.size() > 1:
		var str_parameters: String = node_name.split("_")[1]
		if str_parameters == "movable":
			node.add_child(Node3D.new())
	if scene_dictionnary.has(trimmed_name):
		replace_node_by(node, scene_dictionnary[trimmed_name].instantiate())
	if node is MeshInstance3D:
		replace_material(node)
	for child in node.get_children():
		iterate(child)

func _set_new_owner(node: Node, owner: Node) -> void:
	if node != owner:
		node.owner = owner

func replace_node_by(original_node: Node, new_node: Node) -> void:
	var container: Node3D = original_node.get_parent()
	if !container: return
	var tmp_name: String = original_node.name.capitalize()
	original_node.name = "to_replace"
	container.add_child(new_node)

	new_node.transform = original_node.transform
	new_node.name = tmp_name
	original_node.queue_free()
	_set_new_owner(new_node, root)

func replace_material(node: MeshInstance3D) -> void:
	if node.get_surface_override_material(0) != null:
		return
	var orignal_material: StandardMaterial3D = node.mesh.surface_get_material(0)
	var new_mat: Material
	if node.name.contains("level_block"):
		new_mat = blockout_mat.duplicate()
	
	else:
		new_mat = default_mat.duplicate()
		new_mat.albedo_color = orignal_material.albedo_color
		new_mat.metallic = orignal_material.metallic
		# new_mat.roughness = orignal_material.roughness
		new_mat.albedo_texture = orignal_material.albedo_texture

	node.set_surface_override_material(0, new_mat)