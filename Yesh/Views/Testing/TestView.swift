import SwiftUI

struct TestView: View {
    @State var ingredient: DrinkIngredient = .Vodka
    @State var test: TestStruct = .Vodka
    
    var body: some View {
        Form {
            
            Section {
                List {
                    ForEach(DrinkIngredient.Tags.allCases.map({$0.rawValue}), id: \.self) {str in
                        HStack {
                            Text(str)
                            Spacer()
                            Button {
                                addTag(str)
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                
                Divider()
                
                List {
                    ForEach(TestStruct.Tags.allCases.map({$0.rawValue}), id: \.self) {str in
                        HStack {
                            Text(str)
                            Spacer()
                            Button {
                                addTest(str)
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                
            } header: {
                Text("Tags")
            }
        }
    }
    
    func addTest(_ str: String) {
        print("Pressed button: \(str)")
        
        let tag = TestStruct.Tags(rawValue: str)
        /*
         
        ingredient.addTag(tag!)
        
        print("In view:")
        for tag in ingredient.tags {
                print(tag.rawValue)
        }
         */
        
        test.tags.append(tag!)
        
        print("In view after manual:")
        for tag in test.tags {
                print(tag.rawValue)
        }
    }

    
    func addTag(_ str: String) {
        
        
        print("Pressed button: \(str)")
        
        let tag = DrinkIngredient.Tags(rawValue: str)
        /*
         
        ingredient.addTag(tag!)
        
        print("In view:")
        for tag in ingredient.tags {
                print(tag.rawValue)
        }
         */
        
        ingredient.tags.append(tag!)
        
        print("In view after manual:")
        for tag in ingredient.tags {
                print(tag.rawValue)
        }

    }
}

#Preview {
    TestView()
}
