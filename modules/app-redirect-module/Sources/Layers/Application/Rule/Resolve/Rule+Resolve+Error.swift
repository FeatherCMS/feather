public import FeatherApplication
public import RedirectModule

extension Rule.Resolve.UseCase {
    public enum Error: UseCaseError {
        case notFound
    }
}
