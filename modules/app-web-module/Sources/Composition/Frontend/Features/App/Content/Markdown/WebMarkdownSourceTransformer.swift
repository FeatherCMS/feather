import FeatherContracts

public protocol WebMarkdownSourceTransformer: Sendable {
    var priority: Int { get }

    func transform(
        _ source: String,
        requestPath: String
    ) async -> String
}

public struct WebMarkdownSourceTransformerRequest: Sendable, ExecutionContext {
    public let requestPath: String

    public init(requestPath: String) {
        self.requestPath = requestPath
    }
}
