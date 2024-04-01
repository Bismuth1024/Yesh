//
//  TagEditor.swift
//  Yesh
//
//  Created by Manith Kha on 23/1/2024.
//

import SwiftUI

struct TagEditor<T: Taggable>: View {
    @Binding var object: T
    var isSearchable = false
    @State var tagSearchText = ""
    
    var searchResults: [String] {
        let tags = T.Tags.allCases.filter({!object.hasTag($0)})
            
        let names = tags.map({$0.rawValue})
        
        if !tagSearchText.isEmpty {
            return names.filter({$0.contains(tagSearchText)})
        } else {
            return names
        }
    }
    
    var body: some View {
        NewFlowLayout(alignment: .leading) {
            if object.tags.isEmpty {
                Text("No tags selected")
                    .font(.caption)
                    .foregroundStyle(.gray)
            } else {
                ForEach(object.tags, id: \.self) {tag in
                    Button {
                        object.removeTag(tag)
                    } label: {
                        Label(tag.rawValue, systemImage: "xmark")
                    }
                    .font(.caption)
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
        }
        
        if isSearchable {
            IconTextField("magnifyingglass", text: $tagSearchText, prompt: "Search")
        }

        List {
            ForEach(searchResults, id: \.self) {str in
                HStack {
                    Text(str)
                    Spacer()
                    Button {
                        object.addTag(T.Tags(rawValue: str) ?? (T.Tags(rawValue: "Spirit")!))
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    TagEditor(object: .constant(DrinkIngredient.Vodka))
}
