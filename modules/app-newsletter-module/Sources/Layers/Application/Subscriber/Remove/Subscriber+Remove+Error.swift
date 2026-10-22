import FeatherApplication
import NewsletterModule

extension Subscriber.Remove {
    public enum Error: UseCaseError {
        case campaignNotFound
    }
}
