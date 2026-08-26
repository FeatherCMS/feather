import Hummingbird

@testable import Server

func buildTestRouter(
    modules: AppModules
) throws -> Router<DefaultRequestContext> {
    try buildRouter(modules: modules)
}
