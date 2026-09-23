public import FeatherAdmin
public import Hummingbird

public struct AdminViewAnalyticsNotFound {
    public let controller: any AdminViewAnalyticsNotFoundController

    public init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewAnalyticsNotFoundDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewAnalyticsNotFoundDefaultInteractor(
                        repository: AdminViewAnalyticsNotFoundOpenAPIRepository(
                            api: AnalyticsAdminAPIClient(
                                apiBaseURL: unsafe AppEnvironmentStore.current
                                    .apiBaseURL,
                                sessionToken: context.sessionToken
                            )
                        )
                    ),
                    presenter: AdminViewAnalyticsNotFoundDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}

extension AdminViewAnalyticsNotFound {
    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        controller.route(on: router)
    }
}
