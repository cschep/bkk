//
//  MainView.swift
//  baby ketten
//
//  Created by Christopher Schepman on 7/13/19.
//

import SwiftUI

struct First : View {
    var body: some View {
        VStack {
            Text("Hello")
            Text("BKK")
        }
    }
}

struct FooView : View {
    var body: some View {
        HStack {
            Text("Byebye")
            Text("BKK")
        }
    }
}

struct MainView : View {
    var body: some View {
        TabbedView {
            First().tabItem {
                Image(systemName: "star")
                Text("First")
            }.tag(0)
            
            FooView().tabItem {
                Image(systemName: "circle")
                Text("Second")
            }.tag(1)
        }
    }
}

#if DEBUG
struct MainView_Previews : PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
