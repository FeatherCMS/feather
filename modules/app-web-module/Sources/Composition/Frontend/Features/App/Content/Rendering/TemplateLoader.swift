public import Mustache

public struct TemplateMetadata: Sendable, Equatable {

    public let stylesheets: [String]
    public let scripts: [String]

    public init(
        stylesheets: [String] = [],
        scripts: [String] = []
    ) {
        self.stylesheets = stylesheets
        self.scripts = scripts
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
