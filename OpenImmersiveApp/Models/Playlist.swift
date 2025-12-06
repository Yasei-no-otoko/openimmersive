//
//  Playlist.swift
//  OpenImmersiveApp
//
//  Created by GitHub Copilot on 12/6/24.
//

import Foundation
import OpenImmersive

/// A model representing a playlist of video streams with looping capability.
@Observable
class Playlist {
    /// The list of streams in the playlist.
    private(set) var streams: [StreamModel] = []
    
    /// The index of the currently playing stream (-1 if none).
    private(set) var currentIndex: Int = -1
    
    /// Whether playlist loop mode is enabled.
    var isLoopEnabled: Bool = false
    
    /// Returns the current stream, if any.
    var currentStream: StreamModel? {
        guard currentIndex >= 0 && currentIndex < streams.count else {
            return nil
        }
        return streams[currentIndex]
    }
    
    /// Returns true if the playlist is empty.
    var isEmpty: Bool {
        streams.isEmpty
    }
    
    /// Returns the number of streams in the playlist.
    var count: Int {
        streams.count
    }
    
    /// Returns true if there is a next item to play.
    var hasNext: Bool {
        guard !isEmpty else { return false }
        if isLoopEnabled {
            return true // Always has next when looping
        }
        return currentIndex < streams.count - 1
    }
    
    /// Adds a stream to the playlist.
    /// - Parameter stream: The stream to add.
    func add(_ stream: StreamModel) {
        // Avoid duplicates based on URL
        if !streams.contains(where: { $0.url == stream.url }) {
            streams.append(stream)
        }
    }
    
    /// Removes a stream from the playlist by index.
    /// - Parameter index: The index of the stream to remove.
    func remove(at index: Int) {
        guard index >= 0 && index < streams.count else { return }
        streams.remove(at: index)
        
        // Adjust currentIndex if needed
        if currentIndex >= streams.count {
            currentIndex = max(-1, streams.count - 1)
        }
    }
    
    /// Clears all streams from the playlist.
    func clear() {
        streams.removeAll()
        currentIndex = -1
    }
    
    /// Sets the playlist from an array of streams.
    /// - Parameter newStreams: The new array of streams.
    func setStreams(_ newStreams: [StreamModel]) {
        streams = newStreams
        currentIndex = newStreams.isEmpty ? -1 : 0
    }
    
    /// Starts playback from the beginning of the playlist.
    /// - Returns: The first stream if available, nil otherwise.
    func start() -> StreamModel? {
        guard !isEmpty else { return nil }
        currentIndex = 0
        return streams[currentIndex]
    }
    
    /// Advances to the next stream in the playlist.
    /// - Returns: The next stream if available (loops to start if enabled), nil otherwise.
    func next() -> StreamModel? {
        guard !isEmpty else { return nil }
        
        let nextIndex = currentIndex + 1
        if nextIndex < streams.count {
            currentIndex = nextIndex
            return streams[currentIndex]
        } else if isLoopEnabled {
            // Loop back to the start
            currentIndex = 0
            return streams[currentIndex]
        }
        
        return nil
    }
    
    /// Goes back to the previous stream in the playlist.
    /// - Returns: The previous stream if available, nil otherwise.
    func previous() -> StreamModel? {
        guard !isEmpty else { return nil }
        
        let prevIndex = currentIndex - 1
        if prevIndex >= 0 {
            currentIndex = prevIndex
            return streams[currentIndex]
        } else if isLoopEnabled {
            // Loop back to the end
            currentIndex = streams.count - 1
            return streams[currentIndex]
        }
        
        return nil
    }
    
    /// Sets the current index directly.
    /// - Parameter index: The index to set.
    func setCurrentIndex(_ index: Int) {
        guard index >= 0 && index < streams.count else { return }
        currentIndex = index
    }
    
    /// Stops playlist playback.
    func stop() {
        // Keep the current index but don't auto-advance
        // Caller should disable isLoopEnabled if they want to fully stop
    }
}
