# InchEx [![Deps Status](https://beta.hexfaktor.org/badge/all/github/rrrene/inch_ex.svg)](https://beta.hexfaktor.org/github/rrrene/inch_ex) [![Inline docs](http://inch-ci.org/github/rrrene/inch_ex.svg?branch=master)](http://inch-ci.org/github/rrrene/inch_ex)

InchEx provides a Mix task to give you hints where to improve your inline docs. One Inch at a time.

[Inch CI](http://inch-ci.org) is the corresponding web service that provides continuous coverage analysis for open source projects.



## What can it do?

InchEx is a utility that suggests places in your codebase where documentation can be improved.

If there are no inline-docs yet, InchEx can tell you where to start.



## Installation

Add InchEx as a dependency in your `mix.exs` file.

```elixir
defp deps do
  [{:inch_ex, "~> 0.5", only: [:dev, :test]}]
end
```

After you are done, run this in your shell to fetch the new dependency:

    $ mix deps.get


## Usage

To run Inch, simply type

    $ mix inch

and you will get something like the following:

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

[Inch CI](https://inch-ci.org/) is a web service based on Inch, that provides an evaluation of a project's docs and a corresponding badge:

> [![Inline docs](http://inch-ci.org/github/rrrene/inch_ex.svg?branch=master)](http://inch-ci.org/github/rrrene/inch_ex)

Adding your project to [Inch CI](https://inch-ci.org/) and getting a badge is easy:

```bash
    $ mix inchci.add

                             Adding project to Inch CI ...

    Successfully created build #1
    URL: http://inch-ci.org/github/rrrene/inch_ex

    [ snip ]
```

There is a blog post for [a screenshot and more information](http://trivelop.de/2015/05/19/elixir-inchci-add/).



## Philosophy

Inch was created to help people document their code, therefore it may be more important to look at **what it does not** do than at what it does.

* It does not aim for "fully documented" or "100% documentation coverage".
* It does not tell you to document all your code (neither does it tell you not to).
* It does not impose rules on how your documentation should look like.
* It does not require that, e.g."every method's documentation should be a single line under 80 characters not ending in a period" or that "every class and module should provide a code example of their usage".

Inch takes a more relaxed approach towards documentation measurement and tries to show you places where your codebase *could* use more documentation.



### The Grade System

Inch assigns grades to each module, function, macro or callback in a codebase, based on how complete the docs are.

The grades are:

* `A` - Seems really good
* `B` - Properly documented, but could be improved
* `C` - Needs work
* `U` - Undocumented

Using this system has some advantages compared to plain coverage scores:

* You can get an `A` even if you "only" get 90 out of 100 possible points.
* Getting a `B` is basically good enough.
* Undocumented objects are assigned a special grade, instead of scoring 0%.

The last point might be the most important one: If objects are undocumented, there is nothing to evaluate. Therefore you can not simply give them a bad rating, because they might be left undocumented intentionally.



### Priorities ↑ ↓

Every class, module, constant and method in a codebase is assigned a priority which reflects how important Inch thinks it is to be documented.

This process follows some reasonable rules, like

* it is more important to document public methods than private ones
* it is more important to document methods with many parameters than methods without parameters
* it is not important to document objects marked as `@doc false`

Priorities are displayed as arrows. Arrows pointing north mark high priority objects, arrows pointing south mark low priority objects.



### No overall scores or grades

Inch does not give you a grade for your whole codebase.

"Why?" you might ask. Look at the example below:

    Grade distribution (undocumented, C, B, A):  ▄  ▁ ▄ █

In this example there is a part of code that is still undocumented, but
the vast majority of code is rated A or B.

This tells you three things:

* There is a significant amount of documentation present.
* The present documentation seems good.
* There are still undocumented methods.

Inch does not really tell you what to do from here. It suggests objects and
files that could be improved to get a better rating, but that is all. This
way, it is perfectly reasonable to leave parts of your codebase
undocumented.

Instead of reporting

    coverage: 67.1%  46 ouf of 140 checks failed

and leaving you with a bad feeling, Inch tells you there are still
undocumented objects without judging.

This provides a lot more insight than an overall grade could, because an overall grade for the above example would either be an `A` (if the evaluation ignores undocumented objects) or a weak `C` (if the evaluation includes them).

The grade distribution does a much better job of painting the bigger picture.



## Further information

I will point you to the [original Inch README](https://github.com/rrrene/inch#philosophy) for more information about the Inch project.



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
