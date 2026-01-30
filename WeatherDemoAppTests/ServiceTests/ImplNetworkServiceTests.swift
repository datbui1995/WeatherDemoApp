//
//  ImplNetworkServiceTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
@testable import WeatherDemoApp

final class ImplNetworkServiceTests: XCTestCase {

    private var sut: ImplNetworkService!

    override func setUp() {
        super.setUp()
        sut = ImplNetworkService(session: URLSession.shared)
    }
    
    override func tearDown() {
        MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(
                    url: request.url!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                )!
                return (response, Data())
            }
        sut = nil
        super.tearDown()
    }

    // MARK: - request(_:)
    func test_request_success_decodesResponse() async throws {
        // Arrange
        let json = """
        { "name": "Hanoi" }
        """.data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.host, "test.com")

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, json)
        }

        sut = await ImplNetworkService(session: makeTestSession())

        let endpoint = Endpoint(
            url: "https://test.com",
            queryItems: []
        )

        // Act
        let result: TestDTO = try await sut.request(endpoint)

        // Assert
        XCTAssertEqual(result, TestDTO(value: "Hanoi"))
    }

    func test_request_throwsInvalidResponse_whenStatusCodeIsNot2xx() async {
        // Arrange
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 401,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }

        sut = await ImplNetworkService(session: makeTestSession())
        let endpoint = Endpoint(url: "https://test.com", queryItems: [])

        // Act / Assert
        do {
            let _: TestDTO = try await sut.request(endpoint)
            XCTFail("Expected NetworkError.invalidResponse")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_request_throwsDecodingFailed_whenJSONIsInvalid() async {
        // Arrange
        let invalidJSON = Data("invalid".utf8)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, invalidJSON)
        }

        sut = await ImplNetworkService(session: makeTestSession())
        let endpoint = Endpoint(url: "https://test.com", queryItems: [])

        // Act / Assert
        do {
            let _: TestDTO = try await sut.request(endpoint)
            XCTFail("Expected NetworkError.decodingFailed")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .decodingFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - loadImage(urlString:)

    func test_loadImage_returnsData_whenURLIsValid() async throws {
        // Arrange
        let imageData = Data([0x01, 0x02, 0x03])

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, imageData)
        }

        sut = await ImplNetworkService(session: makeTestSession())

        // Act
        let result = try await sut.loadImage(urlString: "https://image.test/icon.png")

        // Assert
        XCTAssertEqual(result, imageData)
    }

    func test_loadImage_callsURLSession_forRelativeURL() async throws {
        // Arrange
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }

        sut = await ImplNetworkService(session: makeTestSession())

        // Act
        let result = try await sut.loadImage(urlString: "not a url")

        // Assert
        XCTAssertNotNil(result)
    }
    
    func test_request_buildsCorrectURLRequest() async throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Request built")

        MockURLProtocol.requestHandler = { request in
            // Assert URL
            XCTAssertEqual(request.url?.scheme, "https")
            XCTAssertEqual(request.url?.host, "test.com")
            XCTAssertEqual(request.url?.path, "/search")

            let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
            let queryItems = components?.queryItems

            XCTAssertEqual(queryItems?.count, 2)
            XCTAssertTrue(queryItems?.contains(URLQueryItem(name: "q", value: "hanoi")) ?? false)
            XCTAssertTrue(queryItems?.contains(URLQueryItem(name: "limit", value: "10")) ?? false)

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            expectation.fulfill()
            return (response, Data("{}".utf8))
        }

        sut = await ImplNetworkService(session: makeTestSession())

        let endpoint = Endpoint(
            url: "https://test.com/search",
            queryItems: [
                .init(name: "q", value: "hanoi"),
                .init(name: "limit", value: "10")
            ]
        )

        // Act
        let _: EmptyResponse = try await sut.request(endpoint)

        // Assert
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func test_makeRequest_throwsInvalidURL_whenBaseURLIsInvalid() {
        let endpoint = Endpoint(
            url: "😈😈😈",
            queryItems: []
        )

        XCTAssertThrowsError(
            try sut.makeRequest(endpoint)
        ) { error in
            XCTAssertEqual(error as? NetworkError, .invalidURL)
        }
    }
    
    func test_makeRequest_throwsInvalidURL_whenComponentsURLIsNil() {
        let endpoint = Endpoint(
            url: "ht tp:// bad",
            queryItems: [
                URLQueryItem(name: "a", value: String(repeating: "x", count: 10_000))
            ]
        )
        XCTAssertThrowsError(
            try sut.makeRequest(endpoint)
        ) { error in
            XCTAssertEqual(error as? NetworkError, .invalidURL)
        }
    }
    
    func test_makeRequest_throwsInvalidURL_whenSchemeIsMissing() {
        let endpoint = Endpoint(
            url: "example.com",
            queryItems: []
        )

        XCTAssertThrowsError(try sut.makeRequest(endpoint)) { error in
            XCTAssertEqual(error as? NetworkError, .invalidURL)
        }
    }


    func test_makeRequest_returnsValidRequest_whenInputIsValid() throws {
        let endpoint = Endpoint(
            url: "https://example.com",
            queryItems: [
                URLQueryItem(name: "q", value: "swift")
            ]
        )

        let request = try sut.makeRequest(endpoint)

        XCTAssertEqual(
            request.url?.absoluteString,
            "https://example.com?q=swift"
        )
    }

    private func makeTestSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }
}
struct EmptyResponse: Decodable {}
private struct TestDTO: Codable, Equatable {
    let value: String
    enum CodingKeys: String, CodingKey {
        case value = "name"
    }
}
