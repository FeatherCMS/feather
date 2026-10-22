import FeatherWebApp

extension Login {
    struct Router {
        let controller: any Login.Controller.Interface

        init(
            repository: any Login.Repository.Interface,
            templateRenderer: any TemplateRenderer,
            usesSecureCookies: Bool,
            turnstileVerifier: (any AuthTurnstileVerifier)? = nil
        ) {
            self.controller = Login.Controller.Default(
                usesSecureCookies: usesSecureCookies,
                turnstileVerifier: turnstileVerifier,
                buildRuntime: { _, _ in
                    (
                        interactor: Login.Interactor.Default(
                            repository: repository
                        ),
                        presenter: Login.Presenter.Default(
                            templateRenderer: templateRenderer
                        )
                    )
                }
            )
        }
    }
}
