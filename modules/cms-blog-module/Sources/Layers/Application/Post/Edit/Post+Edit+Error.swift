public import BlogModule
public import FeatherApplication

extension Post.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
