public import Mustache

public protocol TemplateLoader: Sendable {
    func load() throws -> [String: MustacheTemplate]
    func loadMetadata() throws -> [String: TemplateMetadata]
}

extension TemplateLoader {

    public func loadMetadata() throws -> [String: TemplateMetadata] {
        [:]
    }
}
