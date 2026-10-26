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
    templateDefinitions: [WebModule.Template.Definition],
    templatePaths: [URL]
) {
    var events = EventRegistry()
    WebModuleWebApp.Event.Handlers.register(in: &events)
    BlogWebApp.Event.Handlers.register(in: &events)
    NewsWebApp.Event.Handlers.register(in: &events)

    let templateProviders = try await events.trigger(
        event: WebModule.Template.Event.Provider(),
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
