import FeatherWebApp

extension Logout {
    struct Router {
        let controller: any Logout.Controller.Interface

        init(
            repository: any Logout.Repository.Interface,
            usesSecureCookies: Bool
        ) {
            self.controller = Logout.Controller.Default(
                buildRuntime: { _, _ in
                    WebAppRuntime(
                        interactor: Logout.Interactor.Default(
                            repository: repository
                        ),
                        presenter: Logout.Presenter.Default(
                            usesSecureCookies: usesSecureCookies
                        )
                    )
                }
            )
        }
    }
}
