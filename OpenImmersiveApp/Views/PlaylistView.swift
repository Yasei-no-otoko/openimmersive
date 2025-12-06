//
//  PlaylistView.swift
//  OpenImmersiveApp
//
//  Created by GitHub Copilot on 12/6/24.
//

import SwiftUI
import OpenImmersive

/// A view displaying the playlist with controls for managing and playing videos.
struct PlaylistView: View {
    let appState: OpenImmersiveAppState
    let playPlaylist: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Playlist")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if !appState.playlist.isEmpty {
                    Button {
                        appState.playlist.clear()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .help("Clear playlist")
                }
            }
            
            if appState.playlist.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "music.note.list")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    
                    Text("No videos in playlist")
                        .foregroundStyle(.secondary)
                    
                    Text("Select videos and tap the \(Image(systemName: "plus.rectangle.on.rectangle")) button to add them.")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                List {
                    ForEach(Array(appState.playlist.streams.enumerated()), id: \.element.id) { index, stream in
                        PlaylistItemRow(
                            stream: stream,
                            index: index,
                            isCurrentItem: index == appState.playlist.currentIndex,
                            onRemove: {
                                appState.playlist.remove(at: index)
                            }
                        )
                    }
                }
                .listStyle(.plain)
                .frame(minHeight: 150, maxHeight: 300)
                
                HStack {
                    Toggle(isOn: Binding(
                        get: { appState.playlist.isLoopEnabled },
                        set: { appState.playlist.isLoopEnabled = $0 }
                    )) {
                        Label("Loop playlist", systemImage: "repeat")
                    }
                    .toggleStyle(.switch)
                    
                    Spacer()
                    
                    Button {
                        playPlaylist()
                    } label: {
                        Label("Play All", systemImage: "play.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(appState.playlist.isEmpty)
                }
            }
        }
        .padding()
        .frame(minWidth: 300)
    }
}

/// A row in the playlist showing a single video item.
struct PlaylistItemRow: View {
    let stream: StreamModel
    let index: Int
    let isCurrentItem: Bool
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            Text("\(index + 1).")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 24, alignment: .trailing)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(stream.title)
                    .lineLimit(1)
                    .fontWeight(isCurrentItem ? .semibold : .regular)
                
                if !stream.details.isEmpty {
                    Text(stream.details)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            if isCurrentItem {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundStyle(.accent)
                    .font(.caption)
            }
            
            Button {
                onRemove()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help("Remove from playlist")
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let appState = OpenImmersiveAppState()
    return PlaylistView(appState: appState, playPlaylist: {})
}
