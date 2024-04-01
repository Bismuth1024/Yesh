//
//  DrinkRowView.swift
//  Yeshica
//
//  Created by Manith Kha on 25/12/2022.
//

import SwiftUI

struct DrinkRowView: View {
    @Binding var wrapper: SessionStore.DrinkWrapper
    
    var body: some View {
        HStack(spacing: 20) {
            ResizeableImageView(imageName: wrapper.drink.imageName, width: 50, height: 50)
            
            VStack {
                Text(wrapper.drink.name)
                
                if let endTime = wrapper.endTime {
                    if endTime == wrapper.startTime {
                        Text(DateHelpers.dateToTime(wrapper.startTime))
                    } else {
                        Text(DateHelpers.twoDatesRangeString(wrapper.startTime, endTime))
                    }
                } else {
                    Text("Started at " + DateHelpers.dateToTime(wrapper.startTime))
                        .foregroundStyle(.blue)
                }
            }

            VStack {
                Text(String(format: "%.2f standards", wrapper.drink.numStandards()))
                
                Text(String(format: "%.2f g sugar", wrapper.drink.totalSugar()))
            }
        }
        .onChange(of: wrapper) { newValue in
            //imageName = newValue.drinkName
        }
        .onAppear() {
            //imageName = drink.drinkName
        }
    }
}

struct DrinkRowView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkRowView(wrapper: .constant(SessionStore.DrinkWrapper.sample))
    }
}
