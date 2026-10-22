import FeatherApplication
import NewsletterModule

extension Subscriber.Subscribe {
    public enum Error: UseCaseError {
        case campaignNotFound
    }
}
