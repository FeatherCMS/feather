import FeatherAdmin
import Foundation
import Hummingbird

public struct AdminGetAnalyticsNotFound {
    public let controller: any AdminGetAnalyticsNotFoundController

    public init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAnalyticsNotFoundDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetAnalyticsNotFoundDefaultInteractor(
                        repository: AdminGetAnalyticsNotFoundOpenAPIRepository(
                            api: AnalyticsAdminAPIClient(
                                apiBaseURL: AppEnvironmentStore.current
                                    .apiBaseURL,
                                sessionToken: context.sessionToken
                            )
                        )
                    ),
                    presenter: AdminGetAnalyticsNotFoundDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}

extension AdminGetAnalyticsNotFound {
    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        controller.route(on: router)
    }
}
