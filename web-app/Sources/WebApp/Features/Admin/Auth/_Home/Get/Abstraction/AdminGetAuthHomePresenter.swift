import Hummingbird

protocol AdminGetAuthHomePresenter: Sendable {

    func renderHome(
        model: AdminGetAuthHomeModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
