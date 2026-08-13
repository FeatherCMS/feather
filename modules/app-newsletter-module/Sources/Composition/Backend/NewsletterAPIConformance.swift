import NewsletterAdminAPI
import NewsletterAppAPI

extension NewsletterBackend: NewsletterAdminAPI.APIProtocol {}
extension NewsletterBackend: NewsletterAppAPI.APIProtocol {}
