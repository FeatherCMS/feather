import SystemApplication

actor MockVariableQueries: VariableQueries {
    private let value: String?

    init(value: String?) {
        self.value = value
    }

    func get(_ id: String) async throws -> String? { value }

    func find(id: String) async throws -> VariableDetail { fatalError("not needed") }

    func list(query: VariableList.Query) async throws -> VariableList {
        .init(items: [])
    }

    func count(query: VariableList.Query) async throws -> Int { 0 }
}
