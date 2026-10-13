import FeatherAdmin
import Hummingbird

struct AdminNewsArticleRuntime: Sendable {
    let interactor: any AdminNewsArticleInteractor
    let presenter: any AdminNewsArticlePresenter
}

typealias AdminNewsArticleRuntimeBuilder =
    @Sendable (
        Request,
        AuthenticatedRequestContext
    ) -> AdminNewsArticleRuntime
