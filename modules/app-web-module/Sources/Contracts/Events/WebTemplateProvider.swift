import Foundation

public protocol WebTemplateProvider: Sendable {
    var templates: [WebTemplateDefinition] { get }
    var bundledTemplatePaths: [URL] { get }
}
