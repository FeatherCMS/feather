import BlogModule

extension Author.Add {
    enum Repository {}
}

extension Author.Add.Repository {
    protocol Interface: Sendable {
        func create(input: Author.Form.Input) async throws
    }
}
