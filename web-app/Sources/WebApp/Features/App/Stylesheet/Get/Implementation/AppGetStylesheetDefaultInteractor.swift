import Hummingbird
import WebStandards

struct AppGetStylesheetDefaultInteractor: AppGetStylesheetInteractor {
    let globalStylesheetCollector: GlobalStylesheetCollector

    func getStyleCSS() async throws -> CSSResponse {
        .init(globalStylesheetCollector.getGlobalStylesheet())
    }
}
