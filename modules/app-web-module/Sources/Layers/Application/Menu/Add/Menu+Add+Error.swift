public import FeatherApplication
public import WebModule

extension Menu.Add.UseCase {
    public struct Error: UseCaseError {
        public let message: String
    }
}
