import Hummingbird

protocol AdminGetBlogHomePresenter: Sendable {

    func renderHome(
        model: AdminGetBlogHomeModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
