import BlogModule

extension Author.Add {
    enum Repository {}
}

extension Author.Add.Repository {
    protocol Interface: Sendable {
        func create(input: BlogAuthorFormInput) async throws
    }
}
