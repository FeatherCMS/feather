public import FeatherModuleKit
public import FeatherWebAdmin
public import FeatherWebShared
public import Hummingbird
import WebModule

extension WebModule.Metadata.Edit {
    public struct Handler: Sendable {
        private let controller: Controller.Default

        public init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            adminEvents: any EventPublisher
        ) {
            controller = Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            ),
                            events: adminEvents
                        ),
                        presenter: Presenter.Default(
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
            configuration: Configuration
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
            configuration: Configuration
        ) async throws -> Response {
            try await controller.postEditMetadataForContent(
                request: request,
                context: context,
                configuration: configuration
            )
        }
    }
}
