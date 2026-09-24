public import Hummingbird

public typealias RuntimeBuilderContext = (
    request: Request,
    context: DefaultRequestContext
)

public typealias RuntimeBuilder<Interactor, Presenter> =
    @Sendable (RuntimeBuilderContext) -> (
        interactor: Interactor,
        presenter: Presenter
    )

public typealias AuthenticatedRuntimeBuilderContext = (
    request: Request,
    context: AuthenticatedRequestContext
)

public typealias AuthenticatedRuntimeBuilder<Interactor, Presenter> =
    @Sendable (AuthenticatedRuntimeBuilderContext) -> (
        interactor: Interactor,
        presenter: Presenter
    )
