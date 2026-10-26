public import NIOHTTP1

public protocol HTTPErrorRepresentable: Error {
    var status: HTTPResponseStatus { get }
    var headers: HTTPHeaders? { get }
    var content: any HTTPErrorContent { get }
}

public extension HTTPErrorRepresentable {
    var headers: HTTPHeaders? { nil }
}
