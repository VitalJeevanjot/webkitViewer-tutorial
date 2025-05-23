//
//  TextField.swift
//  webkitViewer-tutorial
//
//  Created by Jeevanjot Singh on 17/05/25.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var searchField: String
    @Binding var estimatedProgress: Double
    
    var SIMD2Points: [SIMD2<Float>] =
    [
        .init(x: 0, y: 0), .init(x: 0.5, y: 0), .init(x: 1, y: 0),
        .init(x: 0, y: 0.94), .init(x: 0.5, y: 0.5), .init(x: 1, y: 0.94),
        .init(x: 0, y: 1), .init(x: 0.5, y: 1), .init(x: 1, y: 1)
    ]
    
    var colorsInMeshGradientPoints: [Color] = [
        .white,  .white,  .white,
        .yellow, .orange, .blue,
        .orange, .yellow, .indigo
    ]
    
    var body: some View {
        TextField("Search", text: $searchField)
            .font(.system(size: 20))
            .textFieldStyle(.plain)
            .tint(calculatedTextFieldTint(textCount: searchField.count))
            .autocorrectionDisabled()
            .safeAreaPadding(12)
            .foregroundStyle(.black)
            .background {
                // Loading bar.
                GeometryReader { GeometryProxy in
                    VStack(alignment: .leading, spacing: 0) {
                        UnevenRoundedRectangle(topLeadingRadius: 2, topTrailingRadius: 2).fill(LinearGradient(colors: [.orange, .green, .mint], startPoint: .leading, endPoint: .trailing)).frame(width: GeometryProxy.size.width * estimatedProgress, height: 4).opacity(estimatedProgress < 1.0 ? 1.0 : 0.0)
                        Spacer()
                    }
                    
                }
            }
            .background {
                // White text background.
                UnevenRoundedRectangle(bottomLeadingRadius: 25, bottomTrailingRadius: 25)
                    .fill(Color(red: 248/255, green: 248/255, blue: 248/255))
            }
            .overlay {
                // A thin colourful border around text field.
                UnevenRoundedRectangle(bottomLeadingRadius: 25, bottomTrailingRadius: 25)
                    .stroke(MeshGradient(width: 3, height: 3, points: SIMD2Points, colors: colorsInMeshGradientPoints), lineWidth: 2)
            }
    }
    
    func calculatedTextFieldTint(textCount : Int) -> Color {
        if textCount % 5 == 0 {
            return .yellow
        } else if textCount % 3 == 0 {
            return .green
        } else if textCount % 2 == 0 {
            return .red
        } else {
            return .blue
        }
    }
}

//#Preview {
//    TextField()
//}
