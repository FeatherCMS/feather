import Mustache

public protocol TemplateLoader: Sendable {
    func load() throws -> [String: MustacheTemplate]
}
