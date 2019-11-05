//
//  MainView.swift
//  baby ketten
//
//  Created by Christopher Schepman on 7/13/19.
//

import SwiftUI

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
        TabView {
            SearchView().tabItem {
                Image(systemName: "music.mic")
                Text("search")
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
        Group {
            MainView().environment(\.colorScheme, .dark)
            MainView().environment(\.colorScheme, .light)
        }

    }
}
#endif
