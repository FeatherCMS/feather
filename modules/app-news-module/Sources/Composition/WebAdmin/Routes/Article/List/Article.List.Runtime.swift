import FeatherWebAdmin
import NewsApplication
import NewsModule

extension Article.List {
    struct Runtime: Sendable {
        let interactor: any Interactor.Interface
        let presenter: any Presenter.Interface
    }
}
