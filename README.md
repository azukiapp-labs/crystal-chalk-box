# Chalk Box

[![Circle CI](https://circleci.com/gh/azukiapp/crystal-chalk-box/tree/master.svg?style=svg)](https://circleci.com/gh/azukiapp/crystal-chalk-box/tree/master)

Terminal toolbox to paint and embroider :)

## Why

[Colorize](http://crystal-lang.org/api/Colorize.html) is the obvious choice for those who are starting coding on Crystal. However it changes the String class, and that's not a good practice.

Besides that, it doesn't offer ways to handle multiple types of terminal.

Obs: Yes, this lib is similar to the [chalk](https://github.com/chalk/chalk) lib from Node.js. The differences are:

- This lib is written in Crystal (oh really?);
- All-in-one (the style and support modules are integrated);
- This lib doesn't support 256 and TrueColor for now.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  chalk_box:
    github: azukiapp/crystal-chalk-box
```

## Usage

```crystal
require "chalk_box"

module Basic
  extend ChalkBox
  extend self

  def main
    puts chalk.green("green fields")
  end
end

Basic.main
```

## API

### chalk.<style>[.<style>...](*args)

Example: `chalk.red.bold.underline("Hello", "world")`

Chain [styles](#styles) and call the last one as a method with a string argument. Order doesn't matter, and later styles take precedent in case of a conflict. This simply means that `chalk.red.yellow.green` is equivalent to `chalk.green`.

### chalk.enabled

Color support is automatically detected, but you can override it by setting the `enabled` property.

For default enable is instance of `ChalkBox::Supports`.

### ChalkBox::Supports

Detect whether the terminal supports color. Used internally and handled for you, but exposed for convenience.

Can be overridden by the user with the flags `--color` and `--no-color`. For situations where using `--color` is not possible, add an environment variable `FORCE_COLOR` with any value to force color. Trumps `--no-color`.

## Styles

### Modifiers

- `reset`
- `bold`
- `dim`
- `italic` *(not widely supported)*
- `underline`
- `inverse`
- `hidden`
- `strikethrough` *(not widely supported)*

### Colors

- `black`
- `red`
- `green`
- `yellow`
- `blue` *(on Windows the bright version is used as normal blue is illegible)*
- `magenta`
- `cyan`
- `white`
- `gray`

### Background colors

- `bgBlack`
- `bgRed`
- `bgGreen`
- `bgYellow`
- `bgBlue`
- `bgMagenta`
- `bgCyan`
- `bgWhite`

## TODO

- Add examples for `ChalkBox::Styles`;
- Add examples for `ChalkBox::Supports`;
- Add support for 256 colors;
- Add support for truecolor;

## Contributing

1. Fork it ( https://github.com/azukiapp/crystal-chalk-box/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [nuxlli](https://github.com/nuxlli) Everton Ribeiro - creator, maintainer

## License

"Azuki", "azk" and the Azuki logo are copyright (c) 2013-2016 Azuki Serviços de Internet LTDA.

**azk** source code is released under Apache 2 License.

Check LEGAL and LICENSE files for more information.
