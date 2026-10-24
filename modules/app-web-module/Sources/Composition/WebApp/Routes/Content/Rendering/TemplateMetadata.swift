public struct TemplateMetadata: Sendable {
    public let context: [String: any Sendable]

    public init(
        context: [String: any Sendable] = [:]
    ) {
        self.context = context
    }
}
