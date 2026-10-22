import FeatherApplication
import NewsletterModule

extension Subscriber.Add {
    public enum Error: UseCaseError {
        case campaignNotFound
    }
}
