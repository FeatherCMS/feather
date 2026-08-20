public protocol WebTemplateProvider: Sendable {
    var templates: [WebTemplateDefinition] { get }
}
