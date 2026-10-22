import Foundation
import FeatherModuleKit
import WebApplication
import BlogWebAdmin
import BlogWebApp
import NewsFrontend
import WebModuleWebAdmin
import WebModule
import WebModuleWebApp

func buildWebMetadataExtensions() async throws -> (
    templates: [WebPageTemplateOption],
    templateDefinitions: [WebTemplateDefinition],
    templatePaths: [URL]
) {
    var events = EventRegistry()
    WebModuleWebApp.WebEventHandlers.register(in: &events)
    BlogWebApp.Event.Handlers.register(in: &events)
    NewsFrontend.NewsEventHandlers.register(in: &events)

    let templateProviders = try await events.trigger(
        event: WebTemplateProviderEvent(),
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
