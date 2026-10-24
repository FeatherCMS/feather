import BlogModule
import BlogWebShared

extension Post.Add {
    enum Repository {}
}

extension Post.Add.Repository {
    protocol Interface: Sendable {
        func create(input: Post.Form.Input) async throws
    }
}
