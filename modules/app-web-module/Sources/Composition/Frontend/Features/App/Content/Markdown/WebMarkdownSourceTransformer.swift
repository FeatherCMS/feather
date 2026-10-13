public import FeatherContracts

public protocol WebMarkdownSourceTransformer: Sendable {
    var priority: Int { get }

    func transform(
        _ source: String
    ) async -> String
}

public struct WebMarkdownSourceTransformerRequest: ExecutionContext {

    public init() {}
}
