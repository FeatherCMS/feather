import BlogModule

extension Author.Add {
    enum Interactor {}
}

extension Author.Add.Interactor {
    protocol Interface: Sendable {
        func execute(input: BlogAuthorFormInput) async throws
    }
}
