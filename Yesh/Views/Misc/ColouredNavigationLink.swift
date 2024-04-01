//
//  ColouredNavigationLink.swift
//  Yesh
//
//  Created by Manith Kha on 20/1/2024.
//

import SwiftUI

struct ColouredNavigationLink<P: Hashable>: View {
    let str: String
    let value: P?
    let textColour: Color
    let arrowColour: Color
    
    init(
        _ str: String,
        value: P?,
        textColour: Color = .primary, arrowColour: Color = .blue
    ) {
        self.str = str
        self.value = value
        self.textColour = textColour
        self.arrowColour = arrowColour
    }
    
    var body: some View {
        NavigationLink("", value: value)
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
    ColouredNavigationLink("test", value: 1)
}
