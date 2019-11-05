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
            Group {
                Image("SearchLogo")
                    .cornerRadius(5)

                TextField("search!", text: $searchString) {
                    self.delegate?.searchCompleted(with: self.searchString, searchBy: self.searchBy)
                }
                .textFieldStyle(.roundedBorder)
                .font(.largeTitle)
                .padding(.top, 5).padding(.bottom, 5)

                SegmentedControl(selection: $searchBy) {
                    Text("artist").tag("artist")
                    Text("title").tag("title")
                }
            }.padding(.leading, 20).padding(.trailing, 20)

            Spacer()
        }
        .navigationBarTitle(Text("Search"))
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct SearchView_Previews : PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
#endif
