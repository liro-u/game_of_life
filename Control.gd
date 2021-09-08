#add bool with %size or not

#fix resize decalage

#add save button
#add read instance

#fix full_screen grid nn centré et fix espace de la grid

extends Control


var colonne=50
var ligne=50

var torique=false

var mode_progress=0

var death_condition=[]
var birth_condition=[]

var couleur1
var couleur2

export(PackedScene) var node_instance
var compteur=0

var list=[]

var next_birth
var next_death

var is_playing=false

export(NodePath) var timer_path
export(NodePath) var gridContainer_path
export(NodePath) var start_stop_button_path
export(NodePath) var compteur_labbel_path
export(NodePath) var color_picker_1_path
export(NodePath) var color_picker_2_path
export(NodePath) var button_death_condition_path
export(NodePath) var button_birth_condition_path
export(NodePath) var text_enter_timer_path
export(NodePath) var text_mode_progress_path
export(NodePath) var box_timer_path
export(NodePath) var text_enter_colonne_path
export(NodePath) var text_enter_ligne_path
export(NodePath) var text_torique_path

var timer
var gridContainer
var start_stop_button
var compteur_labbel
var color_picker_1
var color_picker_2
var button_death_condition
var button_birth_condition
var text_enter_timer
var text_mode_progress
var box_timer
var text_enter_colonne
var text_enter_ligne
var text_torique

var oscilateur_1="res://list/oscillateur/le clignotant.txt"
var oscilateur_2="res://list/oscillateur/oscillateur seul.txt"
var oscilateur_3="res://list/oscillateur/figure de valentin.txt"
var oscilateur_4="res://list/oscillateur/GrenouilleG.txt"
var oscilateur_5="res://list/oscillateur/La_galaxie_de_kokG.txt"
var oscilateur_6="res://list/oscillateur/CercleFeuG.txt"

var stable_1="res://list/structure stable/la barge.txt"
var stable_2="res://list/structure stable/la miche de pain.txt"
var stable_3="res://list/structure stable/la ruche.txt"
var stable_4="res://list/structure stable/le bateau.txt"
var stable_5="res://list/structure stable/le bloc.txt"
var stable_6="res://list/structure stable/le navire.txt"
var stable_7="res://list/structure stable/le porte avion.txt"
var stable_8="res://list/structure stable/le serpent.txt"
var stable_9="res://list/structure stable/le tube.txt"
var stable_10="res://list/structure stable/l'hamecon.txt"

var canon_1="res://list/canon/CanonG.txt"

var planeur_1="res://list/planeur/planeur.txt"
var planeur_2="res://list/planeur/canon.txt"

var file_oscilateur=oscilateur_1
var file_stable=stable_1
var file_canon=canon_1
var file_planeur=planeur_1


######################
### initialisation ###
######################

func _ready():
	set_path_name()
	randomize()
	set_process(false)
	set_process_input(false)
	set_start_rule_game()
	fill_list(1)
	refresh_color_variable()
	reload_all_grid()
		
func set_path_name():
	timer=get_node(timer_path)
	gridContainer=get_node(gridContainer_path)
	start_stop_button=get_node(start_stop_button_path)
	compteur_labbel=get_node(compteur_labbel_path)
	color_picker_1=get_node(color_picker_1_path)
	color_picker_2=get_node(color_picker_2_path)
	button_death_condition=get_node(button_death_condition_path)
	button_birth_condition=get_node(button_birth_condition_path)
	text_enter_timer=get_node(text_enter_timer_path)
	text_mode_progress=get_node(text_mode_progress_path)
	box_timer=get_node(box_timer_path)
	text_enter_colonne=get_node(text_enter_colonne_path)
	text_enter_ligne=get_node(text_enter_ligne_path)
	text_torique=get_node(text_torique_path)
	
func set_start_rule_game():
	death_condition=[]
	birth_condition=[]
	set_rule_game(button_death_condition,death_condition,0)
	set_rule_game(button_birth_condition,birth_condition,1)
func set_rule_game(condition,condition_list,type):
	for path_condition_node in range(9):
		var node=condition.get_node(str(path_condition_node))
		if node.pressed and type:
			condition_list.append(path_condition_node)
		elif (not node.pressed) and not(type):
			condition_list.append(path_condition_node)
		
		
		
#####################
### list function ###
#####################

func fill_list(type_fill,state_case=0):
	list=[]
	for x in range(ligne):
		list.append([])
		for _y in range(colonne):
			var num
			if type_fill==0:
				num=randi()%2
			else:
				num=state_case
			list[x].append(num)
	
func resize_list():
	for x in range(ligne):
		if len(list)<ligne:
			list.append([])
		for _y in range(colonne):
			if len(list[x])<colonne:
				list[x].append(0)
				
	for _x in range(len(list)-1):
		if len(list)>ligne:
			list.remove(len(list)-1)
			
	for x in range(len(list)):
		for _y in range(len(list[x])-1):
			if len(list[x])>colonne:
				list[x].remove(len(list[x])-1)

#####################
### grid function ###
#####################
	
func reload_all_grid():
	gridContainer.columns=colonne
	for child in gridContainer.get_children():
		child.free()
	for x in range(len(list)):
		for y in range(len(list[x])):
			var newNode=node_instance.instance()
			newNode.name=str(x)+"_"+str(y)
			newNode.x=x
			newNode.y=y
			
			refresh_color_node(list[x][y],newNode)
			
			gridContainer.add_child(newNode)
			
func refresh_grid():
	for x in range(len(list)):
		for y in range(len(list[x])):
			refresh_color(x,y)
			
func refresh_grid_progress():
	compteur+=1
	refresh_compteur_labbel()
	next_birth=[]
	next_death=[]
	for x in range(len(list)):
		for y in range(len(list[x])):
			var tot_live=check_arround(x,y)
			if list[x][y]==1:
				check_death_condition(x,y,tot_live)
			else:
				check_birth_condition(x,y,tot_live)
	apply_progress()
			
func apply_progress():
	for i in next_birth:
		list[i[0]][i[1]]=1
		refresh_color(i[0],i[1])
	for i in next_death:
		list[i[0]][i[1]]=0
		refresh_color(i[0],i[1])
		
			
			
#####################
### File function ###
#####################

func load_list(file_):
	var f =File.new()
	f.open(file_, File.READ)
	var List=[]
	var x=0
	while not f.eof_reached():
		List.append([])
		var line =f.get_line()
		for c in line:
			List[x].append(int(c))
		x+=1
	f.close()
	var List_reverse=[]
		
	return(List)
	
	
	
#####################
### case function ###
#####################

func check_case_state(x,y):
	if torique:
		x=loop(x,ligne)
		y=loop(y,colonne)
		if list[x][y]==1:
			return(1)
	else:
		if(x>=0 and x<ligne and y>=0 and y<colonne):
			if (list[x][y]==1):
				return(1)
	return(0)
	
func check_death_condition(x,y,tot_live):
	for i in death_condition:
		if i==tot_live:
			next_death+=[[x,y]]
	
func check_birth_condition(x,y,tot_live):
	for i in birth_condition:
		if i==tot_live:
			next_birth+=[[x,y]]
			
func check_arround(x,y):
	var tot_live=0
	tot_live+=check_case_state(x-1,y-1)
	tot_live+=check_case_state(x,y-1)
	tot_live+=check_case_state(x+1,y-1)
	tot_live+=check_case_state(x-1,y)
	tot_live+=check_case_state(x+1,y)
	tot_live+=check_case_state(x-1,y+1)
	tot_live+=check_case_state(x,y+1)
	tot_live+=check_case_state(x+1,y+1)
	return(tot_live)
	
func refresh_color(x,y):
	var node=gridContainer.get_node(str(x)+"_"+str(y))
	refresh_color_node(list[x][y], node)
	
func refresh_color_node(type, node):
	match type:
		0:
			node.color=couleur1
		1:
			node.color=couleur2

func loop(x,lim):
	lim-=1
	if x<0:
		x=lim
	if x>lim:
		x=0
	return(x)
	
	
	
#########################
### gameplay function ###
#########################

func start_stop(Bool):
	match mode_progress:
		0:
			set_process(Bool)
			set_process_input(false)
			timer.stop()
		1:
			set_process(false)
			set_process_input(false)
			if Bool:
				timer.start()
			else:
				timer.stop()
		2:
			set_process(false)
			timer.stop()
			set_process_input(Bool)
			
			
func _process(_delta):
	refresh_grid_progress()

func _on_Timer_timeout():
	refresh_grid_progress()
	
func _input(event):
		if event.is_action_pressed("ui_plus"):
			refresh_grid_progress()



##########################
### interface function ###
##########################

func refresh_compteur_labbel():
	compteur_labbel.text=str(compteur)

func refresh_color_variable():
	couleur1=color_picker_1.color
	couleur2=color_picker_2.color
	
	

#######################
### button function ###
#######################

func _on_start_stop_pressed():
	var text_start="lancer"
	var text_stop="arreter"
	if is_playing:
		is_playing=false
		start_stop_button.text=text_start
		start_stop(false)
	else:
		is_playing=true
		start_stop_button.text=text_stop
		start_stop(true)
		
func _on_random_pressed():
	fill_list(0)
	refresh_grid()

func _on_fill_with_life_pressed():
	fill_list(1,1)
	refresh_grid()

func _on_fill_with_death_pressed():
	fill_list(1)
	refresh_grid()

func _on_reset_compteur_pressed():
	compteur=0
	refresh_compteur_labbel()

func _on_ColorPickerButton1_color_changed(color):
	couleur1=color
	refresh_grid()

func _on_ColorPickerButton2_color_changed(color):
	couleur2=color
	refresh_grid()

func _on_valeur_text_entered(new_text):
	if new_text.is_valid_float():
		if float(new_text)>0:
			timer.wait_time=float(new_text)
		else:
			text_enter_timer.text=str(timer.wait_time)
	else:
		text_enter_timer.text=str(timer.wait_time)

func _on_Button_progress_mode_pressed():
	var text_max_speed="vitesse maximum"
	var text_click="par clique"
	var text_timer="par timer"
	mode_progress=(mode_progress+1)%3
	match mode_progress:
		0:
			text_mode_progress.text=text_max_speed
		1:
			text_mode_progress.text=text_timer
			box_timer.visible=true
		2:
			text_mode_progress.text=text_click
			box_timer.visible=false
	if is_playing:
		start_stop(true)
	else:
		start_stop(false)

func _on_valeur_colonne_text_entered(new_text):
	if new_text.is_valid_integer():
		if int(new_text)>0:
			colonne=int(new_text)
		else:
			text_enter_colonne.text=str(colonne)
	else:
		text_enter_colonne.text=str(colonne)
	resize_list()
	reload_all_grid()

func _on_valeur_ligne_text_entered(new_text):
	if new_text.is_valid_integer():
		if int(new_text)>0:
			ligne=int(new_text)
		else:
			text_enter_ligne.text=str(ligne)
	else:
		text_enter_ligne.text=str(ligne)
	resize_list()
	reload_all_grid()

func _on_moins_l_pressed():
	if ligne>1:
		ligne-=1
		text_enter_ligne.text=str(ligne)
		resize_list()
		reload_all_grid()

func _on_plus_l_pressed():
	ligne+=1
	resize_list()
	reload_all_grid()
	text_enter_ligne.text=str(ligne)

func _on_moins_c_pressed():
	if colonne>1:
		colonne-=1
		resize_list()
		reload_all_grid()
		text_enter_colonne.text=str(colonne)

func _on_plus_c_pressed():
	colonne+=1
	resize_list()
	reload_all_grid()
	text_enter_colonne.text=str(colonne)

func _on_torique_toggled(button_pressed):
	torique=button_pressed
	if button_pressed:
		text_torique.text="torique"
	else:
		text_torique.text="non torique"

func _on_load_pressed(file):
	list=load_list(file)
	resize_list()
	refresh_color_variable()
	refresh_grid()

func _on_load_oscilateur_pressed():
	_on_load_pressed(file_oscilateur)

func _on_load_stable_pressed():
	_on_load_pressed(file_stable)
	
func _on_load_canon_pressed():
	_on_load_pressed(file_canon)
	
func _on_load_planeur_pressed():
	_on_load_pressed(file_planeur)

func _on_selection_canon_item_selected(index):
	match index:
		0:
			file_canon=canon_1

func _on_selection_stable_item_selected(index):
	match index:
		0:
			file_stable=stable_1
		1:
			file_stable=stable_2
		2:
			file_stable=stable_3
		3:
			file_stable=stable_4
		4:
			file_stable=stable_5
		5:
			file_stable=stable_6
		6:
			file_stable=stable_7
		7:
			file_stable=stable_8
		8:
			file_stable=stable_9
		9:
			file_stable=stable_10

func _on_selection_oscilateur_item_selected(index):
	match index:
		0:
			file_oscilateur=oscilateur_1
		1:
			file_oscilateur=oscilateur_2
		2:
			file_oscilateur=oscilateur_3
		3:
			file_oscilateur=oscilateur_4
		4:
			file_oscilateur=oscilateur_5
		5:
			file_oscilateur=oscilateur_6



func _on_selection_planeur_item_selected(index):
	match index:
		0:
			file_planeur=planeur_1
		1:
			file_planeur=planeur_2


