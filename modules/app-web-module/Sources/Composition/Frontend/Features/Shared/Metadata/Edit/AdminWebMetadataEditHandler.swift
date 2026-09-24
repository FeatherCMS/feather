public import FeatherAdmin
public import FeatherContracts
public import Hummingbird
import WebContracts

public struct AdminWebMetadataEditHandler: Sendable {
    private let controller: AdminEditWebMetadataDefaultController

    public init(
        apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine,
        adminEvents: any EventPublisher
    ) {
        controller = AdminEditWebMetadataDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebMetadataDefaultInteractor(
                        repository: AdminEditWebMetadataOpenAPIRepository(
                            api: apiBuilder.makeWebAdmin(context)
                        ),
                        events: adminEvents
                    ),
                    presenter: AdminEditWebMetadataDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }

    public func get(
        request: Request,
        context: AuthenticatedRequestContext,
        configuration: AdminWebMetadataEditConfiguration
    ) async throws -> HTMLResponse {
        try await controller.getEditWebMetadataForContent(
            request: request,
            context: context,
            configuration: configuration
        )
    }

    public func post(
        request: Request,
        context: AuthenticatedRequestContext,
        configuration: AdminWebMetadataEditConfiguration
    ) async throws -> Response {
        try await controller.postEditWebMetadataForContent(
            request: request,
            context: context,
            configuration: configuration
        )
    }
}
