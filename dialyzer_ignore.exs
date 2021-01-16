# エラーが出るライブラリ
pass_lib_modules = [HTTPoison, Poison, Vex]

to_elixir_mod_name =
  fn module ->
    to_string(module)
    |> String.split(".")
    |> Enum.with_index
    |> Enum.reject(fn {_mod_name, i} -> i == 0 end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.join(".")
  end

# 関数コールを無視するためのパターン
unknown_function_pass_pattern = &(~r/:0:unknown_function Function #{&1}\.[\w\!\?]+\/[0-9] does not exist\./)

base_rules =
  [
    ~r/lib\/narou\/entity\/\w+\.ex:1:callback_info_missing/,
    {"lib/narou.ex", :no_return},
    {"lib/narou.ex", :unused_fun},
    {"lib/narou.ex", :call         , 107},
    {"lib/narou.ex", :call         , 134},
    {"lib/narou.ex", :pattern_match, 109},
    {"lib/narou.ex", :pattern_match, 111},
    {"lib/narou.ex", :pattern_match, 190},
  ]

base_rules ++
  (Enum.map(pass_lib_modules, to_elixir_mod_name) |> Enum.map(unknown_function_pass_pattern))
