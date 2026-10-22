import FeatherApplication
import NewsletterModule

extension Campaign.Detail {
    public enum Error: UseCaseError {
        case notFound
    }
}
