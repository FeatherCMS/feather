import Foundation
import FeatherContracts
import WebApplication
import BlogFrontend
import NewsFrontend
import WebApplication
import WebFrontend
import WebContracts

func buildWebMetadataExtensions() async throws -> (
    templates: [WebPageTemplateOption],
    templateDefinitions: [WebTemplateDefinition],
    templatePaths: [URL]
) {
    var events = EventRegistry()
    WebFrontend.WebEventHandlers.register(in: &events)
    BlogFrontend.BlogEventHandlers.register(in: &events)
    NewsFrontend.NewsEventHandlers.register(in: &events)

    let templateProviders = try await events.trigger(
        event: WebTemplateProviderEvent(),
        using: WebEventContext()
    )
    let templateDefinitions = templateProviders.flatMap(\.templates)
    return (
        templates: templateDefinitions.map {
            .init(value: $0.id, title: $0.title)
        },
        templateDefinitions: templateDefinitions,
        templatePaths: templateProviders.flatMap(\.bundledTemplatePaths)
    )
}
