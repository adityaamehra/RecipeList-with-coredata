//
//  AddIngredientView.swift
//  Recipe List App
//
//  Created by Adityaa Mehra on 03/07/21.
//

import SwiftUI

struct AddIngredientView: View {
    @Binding var ingredient:[IngredientJSON]
    @State private var name = ""
    @State private var num = ""
    @State private var denom = ""
    @State private var unit = ""
    var body: some View {
        VStack(alignment: .leading){
            Text("Ingredients:").bold().padding(.top , 5)
            HStack{
                TextField("Salt", text: $name)
                TextField("1", text: $num).frame(width:10)
                Text("/")
                TextField("2", text: $denom).frame(width:10)
                TextField("to taste", text: $unit).textCase(.lowercase)
                Button {
                    let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    let cleanedNum = num.trimmingCharacters(in: .whitespacesAndNewlines)
                    let cleanedDenom = denom.trimmingCharacters(in: .whitespacesAndNewlines)
                    let cleanedUnit = unit.trimmingCharacters(in: .whitespacesAndNewlines)

                    if cleanedName == "" || cleanedNum == "" || cleanedNum == "" || cleanedDenom == ""{
                        return
                    }
                    
                    // Create an ingredientJSON object and set its properties
                    let i = IngredientJSON()
                    i.id = UUID()
                    i.name = cleanedName
                    i.num = Int(cleanedNum) ?? 1
                    i.denom = Int(cleanedDenom) ?? 1
                    i.unit = cleanedUnit
                    // Add this ingredient to the list
                    ingredient.append(i)
                    // Clear the text fields
                    name = ""
                    num = ""
                    denom = ""
                    unit = ""
                } label: {
                    Text("Add").underline()
                }
                
            }
            ForEach(ingredient){i in
                Text("\(i.name) , \(i.num ?? 1) / \(i.denom ?? 1) \(i.unit ?? "")")
            }
        }
    }
}
