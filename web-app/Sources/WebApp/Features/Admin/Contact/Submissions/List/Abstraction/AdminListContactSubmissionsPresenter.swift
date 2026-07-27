import Hummingbird

protocol AdminListContactSubmissionsPresenter: Sendable {
    func render(
        items: [AdminContactSubmissionDirectoryItem],
        search: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
