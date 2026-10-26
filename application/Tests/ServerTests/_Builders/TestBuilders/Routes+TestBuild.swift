import Hummingbird
import FeatherWebShared

@testable import Server

func buildTestRouter(
    modules: AppModules
) throws -> Router<DefaultRequestContext> {
    try buildRouter(modules: modules)
}
