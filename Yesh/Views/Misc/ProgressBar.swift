//
//  ProgressBar.swift
//  Yesh
//
//  Created by Manith Kha on 1/2/2024.
//

import SwiftUI

struct VerticalLine: Shape {
    var relativeX: Double = 0.5
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * relativeX, y: 0))
        path.addLine(to: CGPoint(x: rect.width * relativeX , y: rect.height))
        return path
    }
}

struct ProgressBar: View {
    var value: Double = 3
    var target: Double = 10
    
    var body: some View {
        GeometryReader {metrics in
            RoundedRectangle(cornerRadius: 3)
                .frame(width: metrics.size.width * min(value/target, 1))
        }
    }
}

#Preview {
    ProgressBar()
}
