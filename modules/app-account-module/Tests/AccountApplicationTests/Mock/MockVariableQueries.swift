import SystemApplication

actor MockVariableQueries: VariableQueries {
    private let value: String?
    private let mailFromAddress: String

    init(
        value: String?,
        mailFromAddress: String = "configured@example.test"
    ) {
        self.value = value
        self.mailFromAddress = mailFromAddress
    }

    func get(_ id: String) async throws -> String? {
        switch id {
        case "system-settings-mail-from-address":
            mailFromAddress
        case "web-settings-public-base-url":
            value
        default:
            nil
        }
    }

    func find(id: String) async throws -> VariableDetail {
        fatalError("not needed")
    }

    func list(query: VariableList.Query) async throws -> VariableList {
        .init(items: [])
    }

    func count(query: VariableList.Query) async throws -> Int { 0 }
}
