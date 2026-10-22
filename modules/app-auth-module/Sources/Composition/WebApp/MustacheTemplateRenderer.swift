import FeatherWebApp
import Foundation
import Mustache

public struct MustacheTemplateRenderer: TemplateRenderer {
    private let library: MustacheLibrary

    public init() throws {
        guard
            let templatesURL = Bundle.module.url(
                forResource: "Templates",
                withExtension: nil
            )
        else {
            throw CocoaError(.fileNoSuchFile)
        }
        let templateFiles = [
            ("pages/login", "login.mustache"),
            ("pages/magic-link", "magic-link.mustache"),
            ("partials/auth-styles", "auth-styles.mustache"),
        ]
        var templates: [String: MustacheTemplate] = [:]
        for (identifier, filename) in templateFiles {
            let fileURL = templatesURL
                .appendingPathComponent(filename)
            let source = try String(contentsOf: fileURL, encoding: .utf8)
            templates[identifier] = try MustacheTemplate(string: source)
        }
        library = MustacheLibrary(templates: templates)
    }

    public func render(
        template: String,
        context: [String: any Sendable]
    ) throws -> String {
        guard let rendered = library.render(context, withTemplate: template) else {
            throw TemplateRendererError.missingTemplate(template)
        }
        return rendered
    }
}
