public import FeatherApplication
public import BlogModule

extension Tag.Edit.UseCase {
    public struct Error: UseCaseError {
        public let message: String
    }
}
