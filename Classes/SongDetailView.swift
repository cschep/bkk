//
//  SongDetailView.swift
//  baby ketten
//
//  Created by Christopher Schepman on 7/19/19.
//

import SwiftUI

struct SongDetailView: View {
    let song: Song
    
    weak var delegate: SongDetailDelegate?
    
    @State var isFavorite = true
    
    func addFavoriteTapped() {
        self.delegate?.favoriteToggled(for: song)

        withAnimation {
            self.isFavorite.toggle()
        }
    }
    
    func moreByTapped() {
        self.delegate?.artistSearchRequested(for: song)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("KettenSmallWhite")
                
                VStack(alignment: .leading) {
                    Text(song.title)
                        .font(.title)
                    Text(song.artist)
                        .font(.subheadline)
                }
            }
            .padding()
            
            List {
                Section {
                    Button(action: addFavoriteTapped) {
                        HStack {
                            Text("Favorite")
                            Spacer()
                            if isFavorite {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.red)
                                    .animation(.linear(duration: 0.2))
                            }
                        }
                    }

                    Button(action: moreByTapped) {
                        Text("More By This Artist")
                    }
                }
                
                Section(footer: Text("Searches will open a browser window.")) {
                    Text("Lyrics Search")
                    Text("YouTube Search")
                }

            }
            .listStyle(GroupedListStyle())
            .foregroundColor(Color.primary)
        }
        .background(Color("GroupTableViewBackgroundColor"))
        .navigationBarTitle(Text("Details"), displayMode: .inline)
    }
}

#if DEBUG
struct SongDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SongDetailView(song: Song.fighter)
        }
    }
}
#endif
