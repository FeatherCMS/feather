public import FeatherApplication
public import WebModule

extension MenuItem.Detail.UseCase {
    public struct Error: UseCaseError {
        public let message: String
    }
}
