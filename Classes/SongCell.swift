//
//  SongCell.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/21/20.
//

import SwiftUI

struct SongCell : View {
    let song: Song

    var body: some View {
        VStack(alignment: .leading) {
            Text(song.title)
                .font(.headline)
            Text(song.artist)
                .font(.subheadline)
        }
    }
}

struct SongCell_Previews: PreviewProvider {
    static var previews: some View {
        SongCell(song: Song(artist: "Coheed and Cambria", title: "Welcome Home"))
    }
}
