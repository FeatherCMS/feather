import BlogAdminAPI
import BlogAppAPI

extension BlogBackend: BlogAdminAPI.APIProtocol {}
extension BlogBackend: BlogAppAPI.APIProtocol {}
