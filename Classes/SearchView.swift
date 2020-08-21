//
//  SearchView.swift
//  baby ketten
//
//  Created by Christopher Schepman on 7/14/19.
//

import SwiftUI

struct SearchView : View {

    weak var delegate: SearchDelegate?

    @State var searchString = ""
    @State var searchBy = "artist"

    var body: some View {
        VStack {
            Image("SearchLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(5)

            TextField("search!", text: $searchString) {
                self.delegate?.searchCompleted(with: self.searchString, searchBy: self.searchBy)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .font(.largeTitle)
            .padding(.top, 5).padding(.bottom, 5)

            Picker(selection: $searchBy, label: Text("picker")) {
                Text("artist").tag("artist")
                Text("title").tag("title")
            }.pickerStyle(SegmentedPickerStyle())

            Spacer()
        }
        .padding()
        .navigationBarTitle(Text("Search"))
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct SearchView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            SearchView().environment(\.colorScheme, .light)
            SearchView().environment(\.colorScheme, .dark)
        }
    }
}
#endif
