import ContactModule

extension Form.Search {
    enum Model {}
}

extension Form.Search.Model {
    static let pageSize = 20

    struct Item: Sendable {
        let key: String
        let name: String
    }

    struct Result: Sendable {
        let items: [Item]
        let total: Int
    }
}
