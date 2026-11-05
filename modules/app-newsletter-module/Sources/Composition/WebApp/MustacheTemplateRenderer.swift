public import FeatherWebApp
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

        let templateURL = templatesURL.appendingPathComponent(
            "unsubscribe.mustache"
        )
        let source = try String(
            contentsOf: templateURL,
            encoding: .utf8
        )
        library = MustacheLibrary(
            templates: [
                "pages/unsubscribe": try MustacheTemplate(string: source)
            ]
        )
    }

    public func render(
        template: String,
        context: [String: any Sendable]
    ) throws -> String {
        guard let rendered = library.render(context, withTemplate: template)
        else {
            throw TemplateRendererError.missingTemplate(template)
        }
        return rendered
    }
}
