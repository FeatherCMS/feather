public import FeatherApplication
public import BlogModule

extension Post.Edit.UseCase {
    public struct Error: UseCaseError {
        public let message: String
    }
}
