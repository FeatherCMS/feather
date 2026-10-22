import FeatherApplication
import NewsletterModule

extension Subscriber.List {
    public enum Error: UseCaseError {
        case campaignNotFound
    }
}
