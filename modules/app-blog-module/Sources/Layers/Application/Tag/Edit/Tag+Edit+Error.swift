public import BlogModule
public import FeatherApplication

extension Tag.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
