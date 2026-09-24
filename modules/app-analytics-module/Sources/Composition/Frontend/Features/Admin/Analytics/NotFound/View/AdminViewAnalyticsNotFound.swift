public import FeatherAdmin
public import Hummingbird

public struct AdminViewAnalyticsNotFound {
    public let controller: any AdminViewAnalyticsNotFoundController

    public init(
        apiBuilder: AnalyticsAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminViewAnalyticsNotFoundDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewAnalyticsNotFoundDefaultInteractor(
                        repository: AdminViewAnalyticsNotFoundOpenAPIRepository(
                            api: apiBuilder.makeAnalyticsAdmin(context)
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
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        controller.route(on: router)
    }
}
