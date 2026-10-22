public import FeatherApplication
public import WebModule

extension Page.Detail.UseCase {
    public struct Error: UseCaseError {
        public let message: String
    }
}
