import Hummingbird

protocol AdminAddMediaFolderPresenter: Sendable {
    func renderPage(
        model: AdminAddMediaFolderModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
