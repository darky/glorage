# glorage

[![Package Version](https://img.shields.io/hexpm/v/glorage)](https://hex.pm/packages/glorage)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glorage/)
![Erlang-compatible](https://img.shields.io/badge/target-erlang-a2003e)
![JavaScript-compatible](https://img.shields.io/badge/target-javascript-f1e05a)

Gleam thread local storage

```sh
gleam add glorage
```
```gleam
import glorage

pub fn main() {
  use <- glorage.run // init thread local storage

  inc(1) // 2

  inc(7) // 2, because it's cached inside thread local storage

  use n <- glorage.with(inc) // ability to get thread local storage cached value, n is 2
}

fn inc(n) {
  use <- glorage.once(inc) // make function cachable inside thread local storage
  n + 1
}
```

Further documentation can be found at <https://hexdocs.pm/glorage>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
