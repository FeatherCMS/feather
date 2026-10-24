import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        var paths: PathMap = [:]
        paths.merge(NewsletterCampaign.PathCollection().pathMap) {
            current,
            _ in current
        }
        paths.merge(NewsletterIssue.PathCollection().pathMap) { current, _ in
            current
        }
        paths.merge(NewsletterDelivery.PathCollection().pathMap) {
            current,
            _ in current
        }
        paths.merge(NewsletterSubscriber.PathCollection().pathMap) {
            current,
            _ in current
        }
        return paths
    }
}
