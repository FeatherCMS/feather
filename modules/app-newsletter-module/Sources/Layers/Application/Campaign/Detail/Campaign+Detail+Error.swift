public import FeatherApplication
public import NewsletterModule

extension Campaign.Detail {
    public enum Error: UseCaseError {
        case notFound
    }
}
