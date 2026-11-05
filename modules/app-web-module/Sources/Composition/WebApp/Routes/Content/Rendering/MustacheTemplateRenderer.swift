import FeatherWebApp
import Mustache

struct MustacheTemplateRenderer: TemplateRenderer {
    let library: MustacheLibrary

    func render(
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
