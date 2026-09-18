import FeatherAdmin
import FeatherContracts
import Hummingbird
import WebContracts

enum AdminWebPageMetadataRoutes {
    private struct AdminWebPageMetadataDefaultInteractor {
        let events: any EventPublisher

        func getTemplateOptions() async throws -> [WebPageTemplateOption] {
            let providers = try await events.trigger(
                event: WebTemplateProviderEvent(),
                using: WebEventContext()
            )
            return providers
                .flatMap(\.templates)
                .map { .init(value: $0.id, title: $0.title) }
        }
    }

    static func register(
        router: Router<DefaultRequestContext>,
        renderingEngine: any RenderingEngine,
        events: any EventPublisher
    ) {
        let interactor = AdminWebPageMetadataDefaultInteractor(events: events)
        let configuration = AdminWebMetadataEditConfiguration(
            title: "Edit page",
            breadcrumb: WebPageRoutes.breadcrumb,
            description: "Update the page content and publication settings."
        )
        let path = "/admin/web/pages/{id}/edit/metadata/{metadataID}/"
        router.get(RouterPath(path)) { request, context in
            let handler = AdminWebMetadataEditHandler(
                renderingEngine: renderingEngine,
                templateOptions: try await interactor.getTemplateOptions()
            )
            return try await handler.get(
                request: request,
                context: context,
                referenceType: "web.page",
                configuration: configuration
            )
        }
        router.post(RouterPath(path)) { request, context in
            let handler = AdminWebMetadataEditHandler(
                renderingEngine: renderingEngine,
                templateOptions: try await interactor.getTemplateOptions()
            )
            return try await handler.post(
                request: request,
                context: context,
                referenceType: "web.page",
                configuration: configuration
            )
        }
    }
}
