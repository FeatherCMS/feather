import Hummingbird

public typealias RuntimeBuilderContext = (
    request: Request,
    context: DefaultRequestContext
)

public typealias RuntimeBuilder<Interactor, Presenter> =
    @Sendable (RuntimeBuilderContext) -> (
        interactor: Interactor,
        presenter: Presenter
    )
