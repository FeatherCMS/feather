public import NIOHTTP1

public protocol HTTPErrorRepresentable: Error {
    var status: HTTPResponseStatus { get }
    var headers: HTTPHeaders? { get }
    var content: any HTTPErrorContent { get }
}

extension HTTPErrorRepresentable {
    public var headers: HTTPHeaders? { nil }
}
