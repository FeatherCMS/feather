public import Foundation

public protocol TemplateProvider: Sendable {
    var templates: [TemplateDefinition] { get }
    var bundledTemplatePaths: [URL] { get }
}
