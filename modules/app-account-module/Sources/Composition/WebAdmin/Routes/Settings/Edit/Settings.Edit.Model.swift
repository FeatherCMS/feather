import AccountModule

extension Settings.Edit {

    struct Model: Sendable {
        let language: String
        let timezone: String
        let pageSize: Int
    }
}
