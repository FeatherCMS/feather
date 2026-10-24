import UserModule

extension Role.Detail.Repository {
    struct Model: Sendable {
        let id: String
        let key: String
        let name: String
        let notes: String
    }
}
