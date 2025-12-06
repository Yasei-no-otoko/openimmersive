//
//  PlaylistTests.swift
//  OpenImmersiveAppTests
//
//  Created by GitHub Copilot on 12/6/24.
//

import XCTest
@testable import OpenImmersiveApp

/// Tests for the Playlist class functionality.
final class PlaylistTests: XCTestCase {
    
    var playlist: Playlist!
    
    override func setUp() {
        super.setUp()
        playlist = Playlist()
    }
    
    override func tearDown() {
        playlist = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialState() {
        XCTAssertTrue(playlist.isEmpty)
        XCTAssertEqual(playlist.count, 0)
        XCTAssertEqual(playlist.currentIndex, -1)
        XCTAssertNil(playlist.currentStream)
        XCTAssertFalse(playlist.isLoopEnabled)
        XCTAssertFalse(playlist.hasNext)
    }
    
    // MARK: - Add Tests
    
    func testAddSingleStream() {
        let stream = createTestStream(title: "Test Video 1")
        playlist.add(stream)
        
        XCTAssertFalse(playlist.isEmpty)
        XCTAssertEqual(playlist.count, 1)
        XCTAssertEqual(playlist.streams.first?.title, "Test Video 1")
    }
    
    func testAddMultipleStreams() {
        let stream1 = createTestStream(title: "Test Video 1", urlString: "https://example.com/1.m3u8")
        let stream2 = createTestStream(title: "Test Video 2", urlString: "https://example.com/2.m3u8")
        let stream3 = createTestStream(title: "Test Video 3", urlString: "https://example.com/3.m3u8")
        
        playlist.add(stream1)
        playlist.add(stream2)
        playlist.add(stream3)
        
        XCTAssertEqual(playlist.count, 3)
    }
    
    func testAddDuplicateStreamPrevented() {
        let stream = createTestStream(title: "Test Video 1")
        playlist.add(stream)
        playlist.add(stream) // Try adding duplicate
        
        XCTAssertEqual(playlist.count, 1)
    }
    
    // MARK: - Remove Tests
    
    func testRemoveStream() {
        let stream1 = createTestStream(title: "Test Video 1", urlString: "https://example.com/1.m3u8")
        let stream2 = createTestStream(title: "Test Video 2", urlString: "https://example.com/2.m3u8")
        
        playlist.add(stream1)
        playlist.add(stream2)
        playlist.remove(at: 0)
        
        XCTAssertEqual(playlist.count, 1)
        XCTAssertEqual(playlist.streams.first?.title, "Test Video 2")
    }
    
    func testRemoveInvalidIndex() {
        let stream = createTestStream(title: "Test Video 1")
        playlist.add(stream)
        playlist.remove(at: 5) // Invalid index
        
        XCTAssertEqual(playlist.count, 1) // No change
    }
    
    // MARK: - Clear Tests
    
    func testClearPlaylist() {
        let stream1 = createTestStream(title: "Test Video 1", urlString: "https://example.com/1.m3u8")
        let stream2 = createTestStream(title: "Test Video 2", urlString: "https://example.com/2.m3u8")
        
        playlist.add(stream1)
        playlist.add(stream2)
        playlist.clear()
        
        XCTAssertTrue(playlist.isEmpty)
        XCTAssertEqual(playlist.currentIndex, -1)
    }
    
    // MARK: - Start Tests
    
    func testStartEmptyPlaylist() {
        let result = playlist.start()
        XCTAssertNil(result)
    }
    
    func testStartWithStreams() {
        let stream1 = createTestStream(title: "Test Video 1", urlString: "https://example.com/1.m3u8")
        let stream2 = createTestStream(title: "Test Video 2", urlString: "https://example.com/2.m3u8")
        
        playlist.add(stream1)
        playlist.add(stream2)
        
        let result = playlist.start()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.title, "Test Video 1")
        XCTAssertEqual(playlist.currentIndex, 0)
    }
    
    // MARK: - Next Tests (Without Loop)
    
    func testNextWithoutLoop() {
        let stream1 = createTestStream(title: "Test Video 1", urlString: "https://example.com/1.m3u8")
        let stream2 = createTestStream(title: "Test Video 2", urlString: "https://example.com/2.m3u8")
        
        playlist.add(stream1)
        playlist.add(stream2)
        playlist.isLoopEnabled = false
        
        _ = playlist.start()
        let next = playlist.next()
        
        XCTAssertNotNil(next)
        XCTAssertEqual(next?.title, "Test Video 2")
        XCTAssertEqual(playlist.currentIndex, 1)
    }
    
    func testNextAtEndWithoutLoop() {
        let stream1 = createTestStream(title: "Test Video 1", urlString: "https://example.com/1.m3u8")
        let stream2 = createTestStream(title: "Test Video 2", urlString: "https://example.com/2.m3u8")
        
        playlist.add(stream1)
        playlist.add(stream2)
        playlist.isLoopEnabled = false
        
        _ = playlist.start()
        _ = playlist.next() // Move to second
        let next = playlist.next() // Try to move beyond last
        
        XCTAssertNil(next)
        XCTAssertEqual(playlist.currentIndex, 1) // Should stay at last item
    }
    
    // MARK: - Next Tests (With Loop)
    
    func testNextWithLoop() {
        let stream1 = createTestStream(title: "Test Video 1", urlString: "https://example.com/1.m3u8")
        let stream2 = createTestStream(title: "Test Video 2", urlString: "https://example.com/2.m3u8")
        
        playlist.add(stream1)
        playlist.add(stream2)
        playlist.isLoopEnabled = true
        
        _ = playlist.start()
        _ = playlist.next() // Move to second
        let next = playlist.next() // Should loop back
        
        XCTAssertNotNil(next)
        XCTAssertEqual(next?.title, "Test Video 1")
        XCTAssertEqual(playlist.currentIndex, 0)
    }
    
    func testSingleItemLoop() {
        let stream = createTestStream(title: "Test Video 1")
        playlist.add(stream)
        playlist.isLoopEnabled = true
        
        _ = playlist.start()
        let next = playlist.next() // Should loop back to same item
        
        XCTAssertNotNil(next)
        XCTAssertEqual(next?.title, "Test Video 1")
        XCTAssertEqual(playlist.currentIndex, 0)
    }
    
    // MARK: - Previous Tests
    
    func testPreviousWithoutLoop() {
        let stream1 = createTestStream(title: "Test Video 1", urlString: "https://example.com/1.m3u8")
        let stream2 = createTestStream(title: "Test Video 2", urlString: "https://example.com/2.m3u8")
        
        playlist.add(stream1)
        playlist.add(stream2)
        playlist.isLoopEnabled = false
        
        _ = playlist.start()
        _ = playlist.next() // Move to second
        let prev = playlist.previous()
        
        XCTAssertNotNil(prev)
        XCTAssertEqual(prev?.title, "Test Video 1")
        XCTAssertEqual(playlist.currentIndex, 0)
    }
    
    func testPreviousAtStartWithoutLoop() {
        let stream1 = createTestStream(title: "Test Video 1", urlString: "https://example.com/1.m3u8")
        let stream2 = createTestStream(title: "Test Video 2", urlString: "https://example.com/2.m3u8")
        
        playlist.add(stream1)
        playlist.add(stream2)
        playlist.isLoopEnabled = false
        
        _ = playlist.start()
        let prev = playlist.previous() // Try to go before first
        
        XCTAssertNil(prev)
        XCTAssertEqual(playlist.currentIndex, 0) // Should stay at first item
    }
    
    func testPreviousWithLoop() {
        let stream1 = createTestStream(title: "Test Video 1", urlString: "https://example.com/1.m3u8")
        let stream2 = createTestStream(title: "Test Video 2", urlString: "https://example.com/2.m3u8")
        
        playlist.add(stream1)
        playlist.add(stream2)
        playlist.isLoopEnabled = true
        
        _ = playlist.start()
        let prev = playlist.previous() // Should loop to end
        
        XCTAssertNotNil(prev)
        XCTAssertEqual(prev?.title, "Test Video 2")
        XCTAssertEqual(playlist.currentIndex, 1)
    }
    
    // MARK: - HasNext Tests
    
    func testHasNextWhenEmpty() {
        XCTAssertFalse(playlist.hasNext)
    }
    
    func testHasNextWithLoop() {
        let stream = createTestStream(title: "Test Video 1")
        playlist.add(stream)
        playlist.isLoopEnabled = true
        _ = playlist.start()
        
        XCTAssertTrue(playlist.hasNext)
    }
    
    func testHasNextAtEndWithoutLoop() {
        let stream = createTestStream(title: "Test Video 1")
        playlist.add(stream)
        playlist.isLoopEnabled = false
        _ = playlist.start()
        
        XCTAssertFalse(playlist.hasNext)
    }
    
    // MARK: - SetStreams Tests
    
    func testSetStreams() {
        let stream1 = createTestStream(title: "Test Video 1", urlString: "https://example.com/1.m3u8")
        let stream2 = createTestStream(title: "Test Video 2", urlString: "https://example.com/2.m3u8")
        
        playlist.setStreams([stream1, stream2])
        
        XCTAssertEqual(playlist.count, 2)
        XCTAssertEqual(playlist.currentIndex, 0)
    }
    
    func testSetEmptyStreams() {
        let stream = createTestStream(title: "Test Video 1")
        playlist.add(stream)
        
        playlist.setStreams([])
        
        XCTAssertTrue(playlist.isEmpty)
        XCTAssertEqual(playlist.currentIndex, -1)
    }
    
    // MARK: - CurrentStream Tests
    
    func testCurrentStreamBeforeStart() {
        let stream = createTestStream(title: "Test Video 1")
        playlist.add(stream)
        
        XCTAssertNil(playlist.currentStream)
    }
    
    func testCurrentStreamAfterStart() {
        let stream = createTestStream(title: "Test Video 1")
        playlist.add(stream)
        _ = playlist.start()
        
        XCTAssertNotNil(playlist.currentStream)
        XCTAssertEqual(playlist.currentStream?.title, "Test Video 1")
    }
    
    // MARK: - Edge Cases
    
    func testEmptyPlaylistOperations() {
        XCTAssertNil(playlist.start())
        XCTAssertNil(playlist.next())
        XCTAssertNil(playlist.previous())
        XCTAssertNil(playlist.currentStream)
    }
    
    func testRemoveAdjustsCurrentIndex() {
        let stream1 = createTestStream(title: "Test Video 1", urlString: "https://example.com/1.m3u8")
        let stream2 = createTestStream(title: "Test Video 2", urlString: "https://example.com/2.m3u8")
        let stream3 = createTestStream(title: "Test Video 3", urlString: "https://example.com/3.m3u8")
        
        playlist.add(stream1)
        playlist.add(stream2)
        playlist.add(stream3)
        _ = playlist.start()
        _ = playlist.next()
        _ = playlist.next() // currentIndex = 2
        
        playlist.remove(at: 2) // Remove current item
        
        // Current index should be adjusted
        XCTAssertTrue(playlist.currentIndex <= playlist.count - 1 || playlist.currentIndex == -1)
    }
    
    // MARK: - Helper Methods
    
    private func createTestStream(title: String, urlString: String = "https://example.com/test.m3u8") -> StreamModel {
        return StreamModel(
            title: title,
            details: "Test details",
            url: URL(string: urlString)!,
            projection: .equirectangular(fieldOfView: 180.0)
        )
    }
}
