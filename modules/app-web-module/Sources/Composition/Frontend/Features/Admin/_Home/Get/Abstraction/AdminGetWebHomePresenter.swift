import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminGetWebHomePresenter: Sendable {

    func renderHome(
        model: AdminGetWebHomeModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
