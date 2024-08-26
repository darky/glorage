import carpenter/table
import gleam/erlang/process
import gleam/string
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

pub fn run_should_make_ets_test() {
  use <- glorage.run
  let assert Ok(_) = table.ref("glorage " <> process.self() |> string.inspect)
}

pub fn inside_run_should_cache_test() {
  use <- glorage.run
  1 |> inc_with_cache |> should.equal(2)
  2 |> inc_with_cache |> should.equal(2)
}

pub fn inside_run_should_get_cache_test() {
  use <- glorage.run
  1 |> inc_with_cache
  let resp = glorage.get(inc_with_cache)
  resp |> should.equal(2)
}

fn inc_with_cache(n) {
  use <- glorage.once(inc_with_cache)
  n + 1
}
