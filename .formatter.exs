[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test,script,bench}/**/*.{ex,exs}"],
  import_deps: [:prove, :benchee_dsl],
  locals_without_parens: [assert_fail: 3]
]
