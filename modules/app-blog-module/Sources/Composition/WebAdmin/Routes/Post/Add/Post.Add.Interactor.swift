import BlogModule
import BlogWebShared

extension Post.Add {
    enum Interactor {}
}

extension Post.Add.Interactor {
    protocol Interface: Sendable {
        func execute(input: Post.Form.Input) async throws
    }
}
