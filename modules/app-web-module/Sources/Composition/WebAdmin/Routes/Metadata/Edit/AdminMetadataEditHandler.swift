public import FeatherModuleKit
public import FeatherWebAdmin
public import FeatherWebShared
public import Hummingbird
import WebModule

public struct AdminMetadataEditHandler: Sendable {
    private let controller: AdminEditMetadataDefaultController

    public init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        adminEvents: any EventPublisher
    ) {
        controller = AdminEditMetadataDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditMetadataDefaultInteractor(
                        repository: AdminEditMetadataOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        ),
                        events: adminEvents
                    ),
                    presenter: AdminEditMetadataDefaultPresenter(
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
        configuration: AdminMetadataEditConfiguration
    ) async throws -> HTMLResponse {
        try await controller.getEditMetadataForContent(
            request: request,
            context: context,
            configuration: configuration
        )
    }

    public func post(
        request: Request,
        context: AuthenticatedRequestContext,
        configuration: AdminMetadataEditConfiguration
    ) async throws -> Response {
        try await controller.postEditMetadataForContent(
            request: request,
            context: context,
            configuration: configuration
        )
    }
}
