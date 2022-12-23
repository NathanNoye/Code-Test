String getRocketsQuery() => '''
  query {
      rockets(limit: 10) {
        description
        id
        name
        type
        mass {
          kg
        }
        height {
          meters
        }
        engines {
          number
          type
          version
        }
        success_rate_pct
        wikipedia
        stages
        first_flight
      }
    }
''';
