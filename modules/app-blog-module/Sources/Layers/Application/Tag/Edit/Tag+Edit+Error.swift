public import FeatherApplication
public import BlogModule

extension Tag.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
