import BlogModule

extension Author.Add.Interactor {
    protocol Interface: Sendable {
        func execute(input: Author.Form.Input) async throws
    }
}
