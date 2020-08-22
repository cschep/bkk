//
//  SongListView.swift
//  baby ketten
//
//  Created by Christopher Schepman on 7/14/19.
//

import SwiftUI

struct SongListView : View {
    let searchTerm: String
    let songs: [Song]
    
    weak var delegate: SearchListDelegate?
    
    var body: some View {
        List {
            ForEach(songs, id: \.title) { song in
                Button(action: {
                    self.delegate?.selected(song)
                }, label: {
                    SongCell(song: song)
                })
            }
        }
        .navigationBarTitle(Text(searchTerm), displayMode: .inline)
    }
}

#if DEBUG
struct SongListView_Previews : PreviewProvider {
    static var previews: some View {
        SongListView(searchTerm: "joseph", songs: [Song(artist: "Joseph", title: "Fighter")])
    }
}
#endif
