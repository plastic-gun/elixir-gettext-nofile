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
