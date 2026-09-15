import FeatherAdmin
import Hummingbird
import WebContracts

enum AdminWebPageMetadataRoutes {
    static func register(
        router: Router<DefaultRequestContext>,
        renderingEngine: any RenderingEngine,
        templateOptions: [WebPageTemplateOption]
    ) {
        let handler = AdminWebMetadataEditHandler(
            renderingEngine: renderingEngine,
            templateOptions: templateOptions
        )
        let configuration = AdminWebMetadataEditConfiguration(
            title: "Edit page",
            breadcrumb: WebPageRoutes.breadcrumb,
            description: "Update the page content and publication settings."
        )
        let path = "/admin/web/pages/{id}/edit/metadata/{metadataID}/"
        router.get(RouterPath(path)) { request, context in
            try await handler.get(
                request: request,
                context: context,
                referenceType: "web.page",
                configuration: configuration
            )
        }
        router.post(RouterPath(path)) { request, context in
            try await handler.post(
                request: request,
                context: context,
                referenceType: "web.page",
                configuration: configuration
            )
        }
    }
}
