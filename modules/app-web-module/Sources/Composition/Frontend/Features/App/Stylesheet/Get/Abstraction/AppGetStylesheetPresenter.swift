import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AppGetStylesheetPresenter: Sendable {

    func render(
        css: CSSResponse
    ) -> CSSResponse
}
