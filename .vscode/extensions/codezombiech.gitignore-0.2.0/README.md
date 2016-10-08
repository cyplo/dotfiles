# gitignore extension for Visual Studio Code

A extension for Visual Studio Code that assists you in working with `.gitignore` files.


## Features

- Language support for `.gitignore` files
- Add local `.gitignore` by pulling file from the the [github/gitignore](https://github.com/github/gitignore) repository.


## Usage

Start command palette (with <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> or <kbd>F1</kbd>) and start typing `Add gitignore`


## Settings

```JavaScript
{
	// Number of seconds the list of `.gitignore` files retrieved from github will be cached
	"gitignore.cacheExpirationInterval": 3600
}
```


## Roadmap

### v0.1
Basic implementation that allows to pull a single `.gitignore` file

### v0.2
Add language support for `.gitignore` files

### v0.3
Support adding multiple .gitignore files and merge it to a `.gitignore` file


## Changelog

See CHANGELOG.md


## License

See LICENSE file


## Credits

Icon based on the Git logo by Jason Long
