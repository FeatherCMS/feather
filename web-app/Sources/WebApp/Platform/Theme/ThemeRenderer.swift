import Foundation
import Mustache

final class ThemeRenderer: @unchecked Sendable {
    private let library: MustacheLibrary
    private let layoutTemplate = "html"

    init() {
        do {
            self.library = .init(templates: try Self.loadTemplates())
        }
        catch {
            fatalError("Failed to load theme templates: \(error)")
        }
    }

    func render(
        _ context: ThemePageContext
    ) -> HTMLResponse {
        let body = library.render(context.value, withTemplate: context.template.rawValue)
            ?? "<section><p>Theme render failed.</p></section>"
        var layoutContext = context.value
        layoutContext["body"] = body
        let html = library.render(layoutContext, withTemplate: layoutTemplate)
            ?? "<!DOCTYPE html><html lang=\"en-US\"><body><p>Theme render failed.</p></body></html>"
        return .init(content: html)
    }
}

extension ThemeRenderer {
    private static func loadTemplates() throws -> [String: MustacheTemplate] {
        guard let themesURL = Bundle.module.url(
            forResource: "Themes",
            withExtension: nil
        ) else {
            throw CocoaError(.fileNoSuchFile)
        }
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(
            at: themesURL,
            includingPropertiesForKeys: nil
        )

        var templates: [String: MustacheTemplate] = [:]

        while let fileURL = enumerator?.nextObject() as? URL {
            guard fileURL.pathExtension == "mustache" else {
                continue
            }
            let contents = try String(contentsOf: fileURL, encoding: .utf8)
            let relativePath = fileURL.path.replacingOccurrences(
                of: themesURL.path + "/",
                with: ""
            )
            let templateID = String(relativePath.dropLast(".mustache".count))
            templates[templateID] = try MustacheTemplate(string: contents)
        }
        return templates
    }
}
