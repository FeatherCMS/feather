public import FeatherWebApp
import Mustache

public struct DefaultThemeRenderer: PublicThemeRenderer {

    private let fallbackRenderer: any TemplateRenderer
    private let fallbackTemplateMetadata: [String: TemplateMetadata]
    private let templateLoader: any TemplateLoader
    private let templatePath: @Sendable (String) -> String?
    private let layoutTemplate = "html"

    public init(
        templateLoader: any TemplateLoader,
        templatePath: @escaping @Sendable (String) -> String?
    ) throws {
        self.fallbackRenderer = WebMustacheTemplateRenderer(
            library: .init(templates: try templateLoader.load())
        )
        self.fallbackTemplateMetadata = try templateLoader.loadMetadata()
        self.templateLoader = templateLoader
        self.templatePath = templatePath
    }

    public func render(
        templateIdentifier: String?,
        context: [String: any Sendable]
    ) -> WebAppHTMLResponse {
        #if DEBUG
        let renderer: any TemplateRenderer
        let templateMetadata: [String: TemplateMetadata]
        if let templates = try? templateLoader.load() {
            renderer = WebMustacheTemplateRenderer(
                library: .init(templates: templates)
            )
        }
        else {
            renderer = fallbackRenderer
        }
        templateMetadata =
            (try? templateLoader.loadMetadata()) ?? fallbackTemplateMetadata
        #else
        let renderer = fallbackRenderer
        let templateMetadata = fallbackTemplateMetadata
        #endif
        let template =
            templatePath(templateIdentifier ?? "") ?? "pages/default"
        let metadata = templateMetadata[template] ?? .init()
        var templateContext = metadata.context
        if let stylesheets = templateContext["css"] as? [String] {
            templateContext["css"] = stylesheets.map {
                assetURL($0, context: context)
            }
        }
        if let scripts = templateContext["js"] as? [String] {
            templateContext["js"] = scripts.map {
                assetURL($0, context: context)
            }
        }
        var renderContext = context
        renderContext["template"] = templateContext
        let body =
            (try? renderer.render(
                template: template,
                context: renderContext
            )) ?? "<section><p>Theme render failed.</p></section>"
        var layoutContext = renderContext
        layoutContext["body"] = body
        let html =
            (try? renderer.render(
                template: layoutTemplate,
                context: layoutContext
            ))
            ?? "<!DOCTYPE html><html lang=\"en-US\"><body><p>Theme render failed.</p></body></html>"
        return .init(content: html)
    }

    private func assetURL(
        _ path: String,
        context: [String: any Sendable]
    ) -> String {
        guard
            !path.hasPrefix("/")
                && !path.hasPrefix("http://")
                && !path.hasPrefix("https://")
        else {
            return path
        }
        guard let staticBaseURL = context["staticBaseUrl"] as? String else {
            return "/\(path)"
        }
        return "\(staticBaseURL.trimmingTrailingSlash)/\(path)"
    }
}

extension String {

    fileprivate var trimmingTrailingSlash: String {
        var result = self
        while result.hasSuffix("/") {
            result.removeLast()
        }
        return result
    }
}
