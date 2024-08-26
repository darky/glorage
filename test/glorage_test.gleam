import carpenter/table
import gleam/erlang/process
import gleam/int
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
  inc_with_cache
  |> glorage.get
  |> should.equal(2)

  "str" |> str_with_cache
  str_with_cache
  |> glorage.get
  |> should.equal("str test")

  Nil |> combined_with_cache
  combined_with_cache
  |> glorage.get
  |> should.equal("str test2")
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
  let incr = glorage.get(inc_with_cache)
  let str = glorage.get(str_with_cache)
  str <> incr |> int.to_string
}
