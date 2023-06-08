//
//  ContentView.swift
//  
//
//  Created by Dmitry Kononchuk on 14.02.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

#if os(iOS)
import SwiftUI
import PopUpSwift

struct ContentView: View {
    // MARK: - Private Properties
    private let singleLineExampleText = "The iconic Brooklyn Bridge connects Lower Manhattan and Brooklyn Heights. The Brooklyn Bridge was designed by John A. Roebling. Construction began in 1869 and was completed in 1883. At the time, it was the longest suspension bridge in the world. The Brooklyn Bridge connects the boroughs of Manhattan and Brooklyn by spanning the East River. Because of the elevation of the span above the East River and the relatively low-lying shores, the rest of the bridge, sloping down to ground level, extends quite far inland on both sides of the river. Between 1944 and 1954, a comprehensive reconstruction took place. The inner and outer trusses were strengthened, new horizontal stays were installed between the four main cables, the railroad and trolley tracks were removed, the roadways were widened from two lanes to three lanes, and new approach ramps were constructed. Additional approach ramps to the FDR Drive were opened to traffic in 1969. The Brooklyn Bridge was designated a National Historic Landmark in 1964 and a National Historic Civil Engineering Landmark in 1972. The bridge and multiple Manhattan and Brooklyn lots comprising the approaches were designated as NYC Landmarks in 1967. In recent decades, the structure has been refurbished to handle the traffic demands during its second century. In September 2021, a two-way protected bike lane opened along the Brooklyn Bridge, repurposing one lane of vehicular traffic to accommodate the rise of cycling in NYC."
    
    private let multiLineExampleText = """
    Life is like a box of
    chocolates,
    you never know what you’re gonna
    get.
    """
    
    // MARK: - body Property
    var body: some View {
        let image = Image(uiImage: brooklynBridge)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.white.opacity(0.8), lineWidth: 0.9)
            )
            .frame(width: 60, height: 60)
        
        ZStack {
            Color(theia)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    // PopUp with custom style.
                    PopUpView(
                        shape: .heart,
                        shapeColor: .pink.opacity(0.9),
                        text: multiLineExampleText,
                        popUpType: .bottom
                    ) {
                        print("Do something on tapped on the popup.")
                    }
                    .popUpStyle(
                        .customPopUpStyle(
                            textColor: .white.opacity(0.9),
                            backgroundColor: .red.opacity(0.9),
                            borderColor: .white
                        )
                    )
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    // PopUp with specific style.
                    PopUpView(
                        anyView: image,
                        text: singleLineExampleText,
                        isBounceAnimation: true
                    )
                    .popUpStyle(.newYorkPopUpStyle)
                    .padding(.trailing, 20)
                }
                .padding(.top, 180)
                
                Spacer()
                
                HStack {
                    // PopUp with light style (default).
                    PopUpView(
                        shape: .circle,
                        shapeColor: Color(mint),
                        text: singleLineExampleText,
                        popUpType: .bottom,
                        isBounceAnimation: true
                    ) {
                        print("Do something on tapped on the popup.")
                    }
                    .padding(.leading, 80)
                    
                    Spacer()
                    
                    // PopUp with dark style.
                    PopUpView(
                        shape: .circle,
                        shapeColor: .white.opacity(0.8),
                        text: multiLineExampleText,
                        popUpType: .top
                    ) {
                        print("Do something on tapped on the popup.")
                    }
                    .popUpStyle(.darkPopUpStyle)
                    .padding(.trailing, 80)
                }
                .padding(.bottom, 180)
            }
        }
    }
}

// MARK: - Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
