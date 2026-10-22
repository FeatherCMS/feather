import FeatherApplication
import NewsletterModule

extension Issue.Detail {
    public enum Error: UseCaseError {
        case notFound
    }
}
