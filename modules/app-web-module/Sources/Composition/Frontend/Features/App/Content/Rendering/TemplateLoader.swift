public import Mustache

public struct TemplateMetadata: Sendable {

    public let context: [String: any Sendable]

    public init(
        context: [String: any Sendable] = [:]
    ) {
        self.context = context
    }
}

public protocol TemplateLoader: Sendable {
    func load() throws -> [String: MustacheTemplate]
    func loadMetadata() throws -> [String: TemplateMetadata]
}

public extension TemplateLoader {

    func loadMetadata() throws -> [String: TemplateMetadata] {
        [:]
    }
}
