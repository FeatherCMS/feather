import Foundation
import FeatherModuleKit
import WebApplication
import BlogWebAdmin
import BlogWebApp
import NewsWebApp
import WebModuleWebAdmin
import WebModule
import WebModuleWebApp

func buildWebMetadataExtensions() async throws -> (
    templates: [PageTemplateOption],
    templateDefinitions: [TemplateDefinition],
    templatePaths: [URL]
) {
    var events = EventRegistry()
    WebModuleWebApp.EventHandlers.register(in: &events)
    BlogWebApp.Event.Handlers.register(in: &events)
    NewsWebApp.NewsEventHandlers.register(in: &events)

    let templateProviders = try await events.trigger(
        event: TemplateProviderEvent(),
        using: WebModule.Event.Context()
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
