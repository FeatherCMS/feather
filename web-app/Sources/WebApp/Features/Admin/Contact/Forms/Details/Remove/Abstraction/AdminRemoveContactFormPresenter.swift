import Hummingbird

protocol AdminRemoveContactFormPresenter: Sendable {
    func renderConfirmation(id: String, name: String, permissions: Set<String>)
        -> HTMLResponse
}
