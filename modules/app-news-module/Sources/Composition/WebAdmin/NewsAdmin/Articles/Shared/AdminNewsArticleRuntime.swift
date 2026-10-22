import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

struct AdminNewsArticleRuntime: Sendable {
    let interactor: any AdminNewsArticleInteractor
    let presenter: any AdminNewsArticlePresenter
}
