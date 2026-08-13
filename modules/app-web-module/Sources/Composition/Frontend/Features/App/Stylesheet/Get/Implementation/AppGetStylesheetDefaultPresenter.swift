import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebStandards

struct AppGetStylesheetDefaultPresenter: AppGetStylesheetPresenter {
    func render(
        css: CSSResponse
    ) -> CSSResponse {
        css
    }
}
