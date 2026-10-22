import FeatherApplication
import NewsletterModule

extension Campaign.Edit {
    public enum Error: UseCaseError {
        case notFound
    }
}
