import Hummingbird
import FeatherWebShared

@testable import Server

func buildTestRouter(
    modules: AppModules
) throws -> Router<BasicRequestContext> {
    try buildRouter(modules: modules)
}
