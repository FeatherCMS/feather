import BlogModule

extension AuthorLink.Details {
    struct Model: Sendable {
        let id: String
        let authorID: String
        let label: String
        let url: String
        let priority: Int
        let isBlank: Bool
        let permission: String
        let notes: String
    }
}
