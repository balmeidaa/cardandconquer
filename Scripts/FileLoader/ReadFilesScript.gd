extends Node

func load_unit_cards():
    var unit_cards = {}
    var file = File.new()
    file.open("res://DataFiles/unit_file_definitioninition.csv", File.READ)
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


#  var file_path = "res://DataFiles/file_definitioninition.csv"
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
    
    var file_definition = {}
    for row in values:
        var dict = {}
        var unit_id
        for index in row.size():
            if index == 0:
                unit_id =  row[index]
                continue
                
            var key = headers[index]
            var value = row[index]
            var type = types[index]
            dict[key] = cast_values(type, value)
        file_definition[unit_id] = dict
    return file_definition
        
# cast string values to their actual intended value            
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
            return String(value)

#removes empty spaces in the csv file
func clean_array(array):
    
    var arr_size = len(array)
    var to_remove = []
    
    for i in range(arr_size):
        if len(array[i]) == 0:
            to_remove.append(i)
    
    for el in to_remove:
        array.remove(el)
    
    return array
