//
//  URLSessionHTTPClientTests.swift
//  MenuAppTDDTests
//
//  Created by Vinicius Moreira Leal on 23/03/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import XCTest
import MenuAppTDD

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) -> Result<[CategoryItem], Error> {
        session.dataTask(with: url) { _, _, _ in }.resume()
        return .failure(NSError(domain: "Test", code: 1))
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        
        _ = sut.get(from: url)
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let error = NSError(domain: "Test", code: 1)
        session.stub(url: url, error: error)
        
        let sut = URLSessionHTTPClient(session: session)
        
        let result = sut.get(from: url)
        switch result {
        case let .failure(receivedError as NSError):
            XCTAssertEqual(receivedError, error)
        default:
            XCTFail("Expected failure with \(error), got \(result) instead")
        }
    }
    
    // MARK: - Helpers
    
    private class URLSessionSpy: URLSession {
        
        private var stubs = [URL: Stub]()
        
        private struct Stub {
            let task: URLSessionTask
            let error: Error?
        }
        
        override init() {}
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Couldn't find stub for \(url)")
            }
            completionHandler(nil, nil, stub.error)
            return stub.task as! URLSessionDataTask
        }
        
        func stub(url: URL, task: URLSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        
        override init() {}
        
        override func resume() {}
    }
    
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCallCount = 0
        
        override init() {}
        
        override func resume() {
            resumeCallCount += 1
        }
    }
}
