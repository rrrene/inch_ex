# InchEx [![Inline docs](http://inch-ci.org/github/rrrene/inch_ex.svg?branch=master)](http://inch-ci.org/github/rrrene/inch_ex)

InchEx is a wrapper to use [Inch](http://trivelop.de/inch) for Elixir projects.



## Usage

Add InchEx as a dependency in your `mix.exs` file.

```elixir
defp deps do
  [{:inch_ex, only: :docs}]
end
```

After adding you are done, run `mix deps.get` in your shell to fetch the dependencies and `mix inch` to run it:

```bash
    $ mix inch

    # Properly documented, could be improved:

    ┃  B  ↑  Foo.complicated/5

    # Undocumented:

    ┃  U  ↑  Foo
    ┃  U  ↗  Foo.filename/1

    Grade distribution (undocumented, C, B, A):  █  ▁ ▄ ▄
```

If you have Inch installed it will run locally. If not, it will use the API of [inch-ci.org](http://inch-ci.org/) to display results. If you want to specify a certain Inch version you have installed (e.g. for testing), you can set the `INCH_PATH` environment variable.



## Adding a project to Inch CI

Adding your project to [Inch CI](https://inch-ci.org/) and getting a badge is easy:

```bash
    $ mix inchci.add
```

[Read the blog post](http://trivelop.de/2015/05/19/elixir-inchci-add/) for more information.



## Philosophy

I will point you to the [original Inch README](https://github.com/rrrene/inch#philosophy) for an overview of the basic premises and priorities of the Inch project.



## Contributing

1. [Fork it!](http://github.com/rrrene/inch_ex/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request



## Author

René Föhring (@rrrene)



## Credits

InchEx ows its existence to the extensive study and "code borrowing" from ExDoc.



## License

InchEx is released under the MIT License. See the LICENSE file for further
details.
