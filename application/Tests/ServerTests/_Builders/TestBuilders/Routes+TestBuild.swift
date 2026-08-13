import Hummingbird

@testable import Server

func buildTestRouter(
    modules: AppModules
) throws -> Router<AppRequestContext> {
    try buildRouter(modules: modules)
}
