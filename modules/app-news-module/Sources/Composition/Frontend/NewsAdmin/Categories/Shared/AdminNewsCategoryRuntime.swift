import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

struct AdminNewsCategoryRuntime: Sendable {
    let interactor: any AdminNewsCategoryInteractor
    let presenter: any AdminNewsCategoryPresenter
}

typealias AdminNewsCategoryRuntimeBuilder =
    @Sendable (
        Request,
        AuthenticatedRequestContext
    ) -> AdminNewsCategoryRuntime
