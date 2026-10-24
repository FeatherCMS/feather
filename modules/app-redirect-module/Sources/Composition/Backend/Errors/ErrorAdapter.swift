import RedirectApplication
import RedirectDomain
import RedirectModule

public enum ErrorAdapter {

    public static func adapt(_ error: any Error) -> (any Error)? {
        if let error = error as? Rule.Model.Error {
            return RuleModelErrorAdapter(error: error)
        }
        if let error = error as? Rule.Resolve.Error {
            return RuleResolveErrorAdapter(error: error)
        }
        return nil
    }
}
