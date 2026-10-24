public protocol TemplateRenderer: Sendable {
    func render(
        template: String,
        context: [String: any Sendable]
    ) throws -> String
}
