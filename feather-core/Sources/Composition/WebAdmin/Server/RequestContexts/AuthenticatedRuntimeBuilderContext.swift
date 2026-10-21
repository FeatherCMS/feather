public import Hummingbird

public typealias AuthenticatedRuntimeBuilderContext = (
    request: Request,
    context: AuthenticatedRequestContext
)

public typealias AuthenticatedRuntimeBuilder<Interactor, Presenter> =
    @Sendable (AuthenticatedRuntimeBuilderContext) -> (
        interactor: Interactor,
        presenter: Presenter
    )
