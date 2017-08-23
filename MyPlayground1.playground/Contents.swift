//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


//: Playground - noun: a place where people can play

import UIKit

var dict = Dictionary<String, String>()

dict["name"] = "Jordan"
dict["location"] = "Stanford"

print (dict.description)

var str_dict = dict.description

var array = str_dict.components(separatedBy: ", ")

var iterator = 0
var new_dict = Dictionary<String, String>()

for entry in array {
    
    var key_index_start = entry.index(entry.startIndex, offsetBy: 1)
    
    if iterator == 0 {
        
        key_index_start = entry.index(entry.startIndex, offsetBy: 2)
        
    }
    
    let key1 = entry.substring(from: key_index_start)
    
    let key_index_end = key1.characters.index(of: "\"")!
    
    let key2 = key1.substring(to: key_index_end)
    
    let value_index = entry.characters.index(of: ":")!
    
    let value_index_start = entry.index(value_index, offsetBy: 3)
    
    let value1 = entry.substring(from: value_index_start)
    
    let value_index_end = value1.characters.index(of: "\"")!
    
    let value2 = value1.substring(to: value_index_end)
    
    iterator += 1
    
    new_dict[key2] = value2
}

new_dict == dict