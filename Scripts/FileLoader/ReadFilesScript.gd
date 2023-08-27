extends Node

func load_unit_cards():
    var unit_cards = {}
    var file = File.new()
    file.open("res://DataFiles/unit_card_definition.csv", File.READ)
    # skip the first line
    var line = file.get_csv_line(",")
    
    while file.eof_reached() == false:
        line = clean_array(file.get_csv_line(","))
        var cards = []
        for index in range(1, line.size()):
            cards.append(line[index])
        
        unit_cards[line[0]] = cards
    
    print(unit_cards)
    file.close()
    return unit_cards


#  var file_path = "res://DataFiles/card_definition.csv"
func load_file(file_path):    
    var file = File.new()
    file.open(file_path, file.READ)
    
    var headers = file.get_csv_line()
    var types = file.get_csv_line()
    var values = Array()
    
    while !file.eof_reached():
        var line = file.get_csv_line ()
        if line.size() > 1:
            values.append(line)
    file.close()
    
    var card_def = []
    for row in values:
        var dict = {}
        for index in row.size():
            var key = headers[index]
            var value = row[index]
            var type = types[index]
            dict[key] = cast_values(type, value)
        card_def.append(dict)
    return card_def
        
            
func cast_values(type, value):
    if value.empty():
        return null
    
    match(type):
        "float":
            return float(value)
        "int":
            return int(value)
        "bool":
            if value == 'TRUE':
                return true
            return false
        # default string
        _:
            return value


func clean_array(array):
    
    var arr_size = len(array)
    var to_remove = []
    
    for i in range(arr_size):
        if len(array[i]) == 0:
            to_remove.append(i)
    
    for el in to_remove:
        array.remove(el)
    
    return array
