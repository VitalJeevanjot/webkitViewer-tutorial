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
        .yellow, .red, .purple,
        .yellow, .orange, .purple,
        .white,  .white,  .white
    ]
    
    var body: some View {
        TextField("Search", text: $searchField)
            .font(.system(size: 25))
            .textFieldStyle(.plain)
            .tint(calculatedTextFieldTint(textCount: searchField.count))
            .autocorrectionDisabled()
            .safeAreaPadding(12)
            .background {
                GeometryReader { GeometryProxy in
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        UnevenRoundedRectangle(topLeadingRadius: 2, topTrailingRadius: 2).fill(LinearGradient(colors: [.orange, .green, .mint], startPoint: .leading, endPoint: .trailing)).frame(width: GeometryProxy.size.width * estimatedProgress, height: 4).opacity(estimatedProgress < 1.0 ? 1.0 : 0.0)
                    }
                    
                }
            }
            .background {
                UnevenRoundedRectangle(topLeadingRadius: 25, topTrailingRadius: 25)
                    .fill(Color(red: 248/255, green: 248/255, blue: 248/255))
            }
            .overlay {
                UnevenRoundedRectangle(topLeadingRadius: 25, topTrailingRadius: 25)
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
