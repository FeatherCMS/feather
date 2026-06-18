import Hummingbird
import WebStandards

struct AppGetStylesheetDefaultPresenter: AppGetStylesheetPresenter {
    func render(
        css: CSSResponse
    ) -> CSSResponse {
        css
    }
}
