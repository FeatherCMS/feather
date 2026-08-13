import ContactAdminAPI
import ContactAppAPI

extension ContactBackend: ContactAdminAPI.APIProtocol {}
extension ContactBackend: ContactAppAPI.APIProtocol {}
