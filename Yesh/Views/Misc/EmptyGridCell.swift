//
//  EmptyGridCell.swift
//  Yesh
//
//  Created by Manith Kha on 29/11/2023.
//

import SwiftUI

struct EmptyGridCell : View {
    var body: some View {
        return Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
    }
}

#Preview {
    EmptyGridCell()
}
