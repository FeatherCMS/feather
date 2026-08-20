import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import RedirectAdminAPI
import RedirectAppAPI
import RedirectApplication
import RedirectInfrastructure

extension UseCases {

    func makeGetPublicRuleBySource() -> GetPublicRuleBySource {
            let query = DatabaseQueryExecutor(
                database: database,
                scope: { context in
                    ReadRule(
                        rule: RuleDatabaseQueries(
                            context: context
                        )
                    )
                }
            )
            return .init(query: query)
        }
}

