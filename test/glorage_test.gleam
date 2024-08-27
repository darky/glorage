import gleam/int
import gleeunit
import gleeunit/should
import glorage

pub fn main() {
  gleeunit.main()
}

pub fn run_resp_test() {
  let resp = glorage.run(fn() { "test" })
  resp |> should.equal("test")
}

pub fn inside_run_should_cache_test() {
  use <- glorage.run

  1 |> inc_with_cache |> should.equal(2)
  2 |> inc_with_cache |> should.equal(2)
}

pub fn inside_run_should_get_cache_test() {
  use <- glorage.run

  1 |> inc_with_cache
  use resp <- glorage.with(inc_with_cache)
  resp |> should.equal(2)

  "str" |> str_with_cache
  use resp <- glorage.with(str_with_cache)
  resp |> should.equal("str test")

  Nil |> combined_with_cache
  use resp <- glorage.with(combined_with_cache)
  resp |> should.equal("str test2")
}

fn inc_with_cache(n) {
  use <- glorage.once(inc_with_cache)

  n + 1
}

fn str_with_cache(str) {
  use <- glorage.once(str_with_cache)

  str <> " test"
}

fn combined_with_cache(_) {
  use <- glorage.once(combined_with_cache)

  use incr <- glorage.with(inc_with_cache)
  use str <- glorage.with(str_with_cache)

  str <> incr |> int.to_string
}
