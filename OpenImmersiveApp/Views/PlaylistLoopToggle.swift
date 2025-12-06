//
//  PlaylistLoopToggle.swift
//  OpenImmersiveApp
//
//  Created by GitHub Copilot on 12/6/24.
//

import SwiftUI

/// A button to toggle playlist loop mode.
///
/// This view displays a repeat icon that indicates whether playlist loop mode is active.
/// When the playlist is empty, the toggle is disabled.
struct PlaylistLoopToggle: View {
    @Binding var isOn: Bool
    let playlist: Playlist
    
    var body: some View {
        Toggle("", systemImage: "repeat", isOn: $isOn)
            .toggleStyle(.button)
            .controlSize(.extraLarge)
            .tint(isOn ? .accentColor : .clear)
            .disabled(playlist.isEmpty)
            .help(helpText)
    }
    
    private var helpText: String {
        if playlist.isEmpty {
            return "Add videos to playlist to enable loop"
        }
        return isOn ? "Loop playlist (on)" : "Loop playlist (off)"
    }
}

#Preview {
    let playlist = Playlist()
    return PlaylistLoopToggle(isOn: .constant(false), playlist: playlist)
}
