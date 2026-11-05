public import FeatherWebApp
import Foundation
import Mustache
public import WebModule

public struct DefaultThemeRenderer: PublicThemeRenderer {

    private let fallbackRenderer: any TemplateRenderer
    private let fallbackTemplateMetadata: [String: TemplateMetadata]
    private let templateLoader: any TemplateLoader
    private let templatePath: @Sendable (String) -> String?
    private let templateDefinitions: [Template.Definition]
    private let layoutTemplate = "html"

    public init(
        templateLoader: any TemplateLoader,
        templatePath: @escaping @Sendable (String) -> String?,
        templateDefinitions: [Template.Definition] = []
    ) throws {
        self.fallbackRenderer = MustacheTemplateRenderer(
            library: .init(templates: try templateLoader.load())
        )
        self.fallbackTemplateMetadata = try templateLoader.loadMetadata()
        self.templateLoader = templateLoader
        self.templatePath = templatePath
        self.templateDefinitions = templateDefinitions
    }

    public func render(
        templateIdentifier: String?,
        context: [String: any Sendable]
    ) -> WebAppHTMLResponse {
        #if DEBUG
        let renderer: any TemplateRenderer
        let templateMetadata: [String: TemplateMetadata]
        if let templates = try? templateLoader.load() {
            renderer = MustacheTemplateRenderer(
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
        let definition = templateDefinitions.first {
            $0.id == templateIdentifier
        }
        var templateContext = definition.map {
            templateDefaultContext(for: $0.fields)
        } ?? [:]
        for (key, value) in metadata.context {
            if let defaultValue = templateContext[key] {
                templateContext[key] = merge(defaultValue, with: value)
            }
            else {
                templateContext[key] = value
            }
        }
        if let page = context["page"] as? [String: any Sendable],
            let templateData = page["templateData"] as? String,
            let data = templateValues(templateData)
        {
            for (key, value) in data {
                if let defaultValue = templateContext[key] {
                    templateContext[key] = merge(
                        defaultValue,
                        with: value
                    )
                }
                else {
                    templateContext[key] = value
                }
            }
        }
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

    private func templateValues(
        _ encodedValues: String
    ) -> [String: any Sendable]? {
        guard
            let data = encodedValues.data(using: .utf8),
            let value = try? JSONDecoder().decode(
                Template.Value.self,
                from: data
            ),
            case .object(let values) = value
        else {
            return nil
        }
        return values.mapValues(\.sendableValue)
    }

    private func templateDefaultContext(
        for fields: [Template.Field]
    ) -> [String: any Sendable] {
        var values: [String: any Sendable] = [:]
        for field in fields {
            if case .object(let children) = field.kind {
                values[field.key] = templateDefaultObject(
                    for: children
                ).sendableValue
            }
            else if let defaultValue = field.defaultValue {
                values[field.key] = defaultValue.sendableValue
            }
        }
        return values
    }

    private func templateDefaultObject(
        for fields: [Template.Field]
    ) -> Template.Value {
        var values: [String: Template.Value] = [:]
        for field in fields {
            if case .object(let children) = field.kind {
                values[field.key] = templateDefaultObject(for: children)
            }
            else if let defaultValue = field.defaultValue {
                values[field.key] = defaultValue
            }
        }
        return .object(values)
    }

    private func merge(
        _ defaultValue: any Sendable,
        with pageValue: any Sendable
    ) -> any Sendable {
        guard
            var merged = defaultValue as? [String: any Sendable],
            let pageObject = pageValue as? [String: any Sendable]
        else {
            return pageValue
        }
        for (key, value) in pageObject {
            if let defaultValue = merged[key] {
                merged[key] = merge(defaultValue, with: value)
            }
            else {
                merged[key] = value
            }
        }
        return merged
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
