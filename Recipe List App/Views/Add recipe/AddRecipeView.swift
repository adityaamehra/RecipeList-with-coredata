//
//  AddRecipeView.swift
//  Recipe List App
//
//  Created by Adityaa Mehra on 03/07/21.
//
import SwiftUI

struct AddRecipeView:View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var name = ""
    @State private var summary = ""
    @State private var prepTime = ""
    @State private var cookTime = ""
    @State private var totalTime = ""
    @State private var servings = ""
    
    // List type recipe meta data
    @State private var highlights = [String]()
    @State private var directions = [String]()
    // Ingredient data
    @State private var ingredients = [IngredientJSON]()
    // Recipe image
    @State private var recipeImage:UIImage?
    // Image picker
    @State private var isShowingImagePicker = false
    @State private var  selectedImageSource = UIImagePickerController.SourceType.photoLibrary
    @State private var placeholderImage = Image("placeholder")
    var body: some View {
        
        VStack {
            
            // HStack with the form controls
            HStack {
                Button {
                    // Clear the form
                    clear()
                } label: {
                    Text("Clear").underline()
                }
                Spacer()
                
                Button {
                    // Add the recipe to core data
                    addRecipe()
                    // Clear the form
                    clear()
                } label:{
                    Text("Save").underline()
                }
            }
            
            // Scrollview
            ScrollView (showsIndicators: false) {
                
                VStack {
                    // Recipe Image
                    placeholderImage.resizable().scaledToFit()
                    HStack{
                        Spacer()
                        Button {
                            // Add Photo from gallery
                            selectedImageSource = .photoLibrary
                            isShowingImagePicker = true
                        } label: {
                            HStack{
                                Image(systemName: "arrow.down.app.fill")
                                Text("Photo library").underline()
                            }
                        }
                        Spacer()
                        Button {
                            // Add photo from the camera
                            selectedImageSource = .camera
                            isShowingImagePicker = true
                        } label: {
                            HStack{
                                Image(systemName: "camera")
                                Text("Camera").underline()
                            }
                        }
                        Spacer()
                    }.sheet(isPresented: $isShowingImagePicker , onDismiss:loadImage) {
                        ImagePicker(selectedSource: selectedImageSource, recipeImage: $recipeImage)
                    }
                    // The recipe meta data
                    AddMetaData(name: $name,
                                summary: $summary,
                                prepTime: $prepTime,
                                cookTime: $cookTime,
                                totalTime: $totalTime,
                                servings: $servings)
                    
                    // List data
                    AddListData(list: $highlights, title: "Highlights", placeholderText: "Vegetarian")
                    
                    AddListData(list: $directions, title: "Directions", placeholderText: "Add the oil to the pan")
                    AddIngredientView(ingredient: $ingredients)
                    
                }
                
            }
            
        }
        .padding(.horizontal)
        
    }
    func clear(){
        name = ""
        summary = ""
        prepTime = ""
        cookTime = ""
        totalTime = ""
        servings = ""
        placeholderImage = Image("placeholder")
        // List type recipe meta data
        highlights = [String]()
        directions = [String]()
        // Ingredient data
        ingredients = [IngredientJSON]()
    }
    func addRecipe(){
        let recipe = Recipe(context: viewContext)
        recipe.id = UUID()
        recipe.name = name
        recipe.cookTime = cookTime
        recipe.prepTime = prepTime
        recipe.totalTime = totalTime
        recipe.servings = Int(servings) ?? 1
        recipe.directions = directions
        recipe.highlights = highlights
        recipe.image = recipeImage?.pngData()
        recipe.summary = summary
        recipe.featured = true
        for i in ingredients{
            let ing = Ingredient(context: viewContext)
            ing.id = UUID()
            ing.unit = i.unit
            ing.num = i.num ?? 1
            ing.denom = i.denom ?? 1
            recipe.addToIngredients(ing)
        }
        do {
            try viewContext.save()
        }
        catch {
            
        }
    }
    func loadImage(){
        if recipeImage != nil{
            placeholderImage = Image(uiImage: recipeImage!)
        }
    }
}
