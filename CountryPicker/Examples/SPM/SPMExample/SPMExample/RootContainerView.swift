//
//  RootContainerView.swift
//  CountryPicker13+Example
//
//  Created by ANKUSH BHATIA on 8/13/23.
//

import SwiftUI

struct RootContainerView: View {
    
    @State var tabSelection = 1
    
    var body: some View {
        TabView(selection: $tabSelection) {
            MainView()
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Main")
                    }
                }
                .tag(1)
            
            CountryPickerWheelDemoView()
                .tabItem {
                    Image(systemName: "circle.dotted")
                    Text("CountryPickerWheel")
                }
                .tag(2)
        }
    }
}

struct RootContainerView_Previews: PreviewProvider {
    static var previews: some View {
        RootContainerView()
    }
}
