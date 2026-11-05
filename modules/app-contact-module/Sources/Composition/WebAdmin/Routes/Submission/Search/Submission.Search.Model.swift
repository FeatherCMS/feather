import ContactApplication
import ContactModule

extension Submission.Search {
    struct Model: Sendable {
        struct Item: Sendable {
            let id: String
            let formKey: String
            let formName: String
            let status: String
            let createdAt: String
            let email: String?
        }

        let items: [Item]
        let total: Int
    }
}
