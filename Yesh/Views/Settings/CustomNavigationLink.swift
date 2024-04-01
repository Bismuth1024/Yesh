//
//  CustomNavigationLink.swift
//  Yesh
//
//  Created by Manith Kha on 18/1/2024.
//

import SwiftUI

struct CustomNavigationLink<Destination: View, P>: View {
    
    init(
        _ str: String,
        value: P?,
        textColour: Color = .black, arrowColour: Color = .blue, @ViewBuilder destination: () -> Destination
    ) where P : Hashable {
        self.value = value
        self.str = str
        self.textColour = textColour
        self.arrowColour = arrowColour
        self.content = destination()
    }
    
    let str: String
    let value: P?
    let textColour: Color
    let arrowColour: Color
    let content: Destination
    
    var body: some View {
        NavigationLink(destination: content) {}
               .opacity(0)
               .background(
                 HStack {
                    Text(str)
                    Spacer()
                    Image(systemName: "chevron.right")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 7)
                      .foregroundColor(arrowColour) //Apply color for arrow only
                      //.navigationTitle(str)

                  }
                  .foregroundColor(textColour)
               )
    }
    
}

#Preview {
    CustomNavigationLink("test", value: 2) {
        Text("A")
    }
}
