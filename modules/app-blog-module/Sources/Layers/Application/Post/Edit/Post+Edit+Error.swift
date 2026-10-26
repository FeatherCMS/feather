public import FeatherApplication
public import BlogModule

extension Post.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
