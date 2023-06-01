# elixir-gettext-no-file

## To Reproduce

```
$ mix deps.get

$ mix gettext.extract # fine

$ mix gettext.merge priv/gettext --locale en_US
Created directory priv/gettext/en_US/LC_MESSAGES

15:20:49.071 [error] Task #PID<0.166.0> started from #PID<0.95.0> terminating
** (ArgumentError) could not load module Demo.Plural due to reason :nofile
    (elixir 1.14.5) lib/code.ex:1643: Code.ensure_compiled!/1
    lib/gettext/plural.ex:371: Gettext.Plural.plural_info/3
    lib/gettext/merger.ex:333: Gettext.Merger.put_plural_forms_opt/3
    lib/gettext/merger.ex:254: Gettext.Merger.new_po_file/4
    lib/mix/tasks/gettext.merge.ex:229: Mix.Tasks.Gettext.Merge.merge_or_create/5
    lib/mix/tasks/gettext.merge.ex:207: anonymous fn/5 in Mix.Tasks.Gettext.Merge.merge_dirs/5
    (elixir 1.14.5) lib/task/supervised.ex:89: Task.Supervised.invoke_mfa/2
    (elixir 1.14.5) lib/task/supervised.ex:34: Task.Supervised.reply/4
Function: &:erlang.apply/2
    Args: [#Function<2.56149135/1 in Mix.Tasks.Gettext.Merge.merge_dirs/5>, ["priv/gettext/default.pot"]]
** (EXIT from #PID<0.95.0>) an exception was raised:
    ** (ArgumentError) could not load module Demo.Plural due to reason :nofile
        (elixir 1.14.5) lib/code.ex:1643: Code.ensure_compiled!/1
        lib/gettext/plural.ex:371: Gettext.Plural.plural_info/3
        lib/gettext/merger.ex:333: Gettext.Merger.put_plural_forms_opt/3
        lib/gettext/merger.ex:254: Gettext.Merger.new_po_file/4
        lib/mix/tasks/gettext.merge.ex:229: Mix.Tasks.Gettext.Merge.merge_or_create/5
        lib/mix/tasks/gettext.merge.ex:207: anonymous fn/5 in Mix.Tasks.Gettext.Merge.merge_dirs/5
        (elixir 1.14.5) lib/task/supervised.ex:89: Task.Supervised.invoke_mfa/2
        (elixir 1.14.5) lib/task/supervised.ex:34: Task.Supervised.reply/4
```

## What is wrong?

The module `Demo.Plural` exists indeed. Here's why:

reason 1 - you can load and compile the module manually:

```
$ iex -S mix
iex(1)> Code.ensure_compiled(Demo.Plural)
{:module, Demo.Plural}
```

reason 2 - after compilation, you can see the `.beam`:

```
$ ls _build/dev/lib/demo/ebin/Elixir.Demo.Plural.beam
-rw-r--r--  1 c4710n  staff  1980 Jun  1 15:19 _build/dev/lib/demo/ebin/Elixir.Demo.Plural.beam
```

But, why does `mix gettext.merge` still complain about `could not load module Demo.Plural due to reason :nofile`?

## The problem

I suspected the problem lies with the load path, so I injected the code at [lib/gettext/plural.ex](https://github.com/plastic-forks/gettext/blob/d596823794ce0c8791ee9f8187698a4b60610f94/lib/gettext/plural.ex#L405):

```elixir
defp ensure_compiled!(mod) do
  :code.get_path() |> IO.inspect(structs: false, limit: :infinity, printable_limit: :infinity)

  Code.ensure_compiled!(mod)
end
```

And, run `mix gettext.merge priv/gettext --locale en_US` again, it output:

```elixir
[
  '/Users/c4710n/_BASTION_/store/src/plastic-gun/elixir-gettext-nofile/_build/dev/lib/gettext/ebin',
  '/Users/c4710n/_BASTION_/store/src/plastic-gun/elixir-gettext-nofile/_build/dev/lib/expo/ebin',
  '/nix/store/5gwd9qwkm2qni672p0qrii8wiii7lj0x-elixir-1.14.5/lib/elixir/bin/../lib/mix/ebin',
  '/nix/store/5gwd9qwkm2qni672p0qrii8wiii7lj0x-elixir-1.14.5/lib/elixir/bin/../lib/logger/ebin',
  '/nix/store/5gwd9qwkm2qni672p0qrii8wiii7lj0x-elixir-1.14.5/lib/elixir/bin/../lib/iex/ebin',
  '/nix/store/5gwd9qwkm2qni672p0qrii8wiii7lj0x-elixir-1.14.5/lib/elixir/bin/../lib/ex_unit/ebin',
  '/nix/store/5gwd9qwkm2qni672p0qrii8wiii7lj0x-elixir-1.14.5/lib/elixir/bin/../lib/elixir/ebin',
  '/nix/store/5gwd9qwkm2qni672p0qrii8wiii7lj0x-elixir-1.14.5/lib/elixir/bin/../lib/eex/ebin',
  '.',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/kernel-8.5.4/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/stdlib-4.3.1/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/xmerl-1.3.31/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/wx-2.2.2/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/tools-3.5.3/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/tftp-1.0.4/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/syntax_tools-3.0.1/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/ssl-10.9.1/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/ssh-4.15.3/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/snmp-5.13.5/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/sasl-4.2/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/runtime_tools-1.19/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/reltool-0.9.1/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/public_key-1.13.3/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/parsetools-2.4.1/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/os_mon-2.8.2/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/observer-2.14/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/mnesia-4.21.4/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/megaco-4.4.3/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/inets-8.3.1/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/ftp-1.1.4/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/eunit-2.8.2/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/et-1.6.5/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/erts-13.2.2/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/erl_interface-5.3.2/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/erl_docgen-1.4/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/eldap-1.2.11/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/edoc-1.2/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/diameter-2.2.7/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/dialyzer-5.0.5/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/debugger-5.3.1/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/crypto-5.1.4/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/compiler-8.2.6/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/common_test-1.24/ebin',
  '/nix/store/pw7y57czjv9bclcnsz23ndf0hwmx6blk-erlang-25.3.2/lib/erlang/lib/asn1-5.0.21/ebin',
  '/Users/c4710n/.mix/archives/phx_new-1.7.2/phx_new-1.7.2/ebin',
  '/Users/c4710n/.mix/archives/hex-1.0.1/hex-1.0.1/ebin'
]
```

As you can see, there is no line like:

```
# the load path of current app
'/Users/c4710n/_BASTION_/store/src/plastic-gun/elixir-gettext-nofile/_build/dev/lib/demo/ebin'
```

That's the reason of this problem - the app is not loaded at all in this case.

## The solution

```sh
$ mix do loadpaths + gettext.merge priv/gettext --locale en_US
```

That's it.

However, it would be better to provide feedback to the upstream to reduce the usage cost for other developers.
