public protocol MarkdownSourceTransformer: Sendable {
    var priority: Int { get }

    func transform(
        _ source: String
    ) async -> String
}
