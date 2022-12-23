import 'package:graphql/client.dart';

// A service to handle API calls
class ApiService {
  // The main function that handles the GraphQL queries
  Future<Map<String, dynamic>> graphQL({
    required String url,
    required String query,
  }) async {
    try {
      final _httpLink = HttpLink(
        url,
      );

      final GraphQLClient client = GraphQLClient(
        cache: GraphQLCache(),
        link: _httpLink,
      );

      final QueryOptions options = QueryOptions(
        document: gql(query),
      );

      final QueryResult result = await client.query(options);

      return result.data ?? {};
    } catch (exception) {
      throw exception;
    }
  }
}
