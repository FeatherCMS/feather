public import FeatherApplication
public import RedirectModule

extension Rule.Edit.UseCase {
    public struct Error: UseCaseError {
        public let message: String
    }
}
