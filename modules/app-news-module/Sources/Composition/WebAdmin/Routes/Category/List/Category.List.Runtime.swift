import NewsApplication
import NewsModule

extension Category.List {
    struct Runtime: Sendable {
        let interactor: any Interactor.Interface
        let presenter: any Presenter.Interface
    }
}
