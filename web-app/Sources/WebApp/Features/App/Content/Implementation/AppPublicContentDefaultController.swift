import Hummingbird

struct AppPublicContentDefaultController: AppPublicContentController {
    let buildRuntime:
        @Sendable () -> (
            interactor: any AppPublicContentInteractor,
            presenter: any AppPublicContentPresenter
        )

    func getSingleSegment(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        try await render(path: request.uri.path, request: request, context: context)
    }

    func getDoubleSegment(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        try await render(path: request.uri.path, request: request, context: context)
    }
}

extension AppPublicContentDefaultController {
    fileprivate func render(
        path: String,
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime()
        guard let content = try await interactor.resolve(path: path) else {
            throw HTTPError(.notFound)
        }
        if shouldRedirectHomePage(content: content) {
            return .init(
                status: .movedPermanently,
                headers: [.location: "/"]
            )
        }
        return try presenter.render(content: content, request: request)
            .response(from: request, context: context)
    }

    fileprivate func shouldRedirectHomePage(
        content: AppPublicResolvedContent
    ) -> Bool {
        guard
            let homePageId = content.siteSettings.homePageId?
                .trimmingCharacters(in: .whitespacesAndNewlines),
            !homePageId.isEmpty
        else {
            return false
        }
        guard case .pageDetail(let detail, _) = content.route else {
            return false
        }
        return detail.id == homePageId
    }
}
