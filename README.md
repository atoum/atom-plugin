# Atom plugin [![Build Status](https://travis-ci.org/atoum/atom-plugin.svg?branch=master)](https://travis-ci.org/atoum/atom-plugin)

<p align="center">
    <img src="http://atoum.org/images/logo/atoum.png" alt="atoum"/>
    <img src="https://raw.githubusercontent.com/atom/atom/master/resources/app-icons/stable/png/128.png" alt="atom"/>
    <br/><br/>
    <img src="https://raw.githubusercontent.com/atoum/atom-plugin/master/resources/preview.png" alt="atoum-plugin"/>
</p>

## Commands & keymaps

| Command                              | Description                                                    | Binding                                                                             |
|--------------------------------------|----------------------------------------------------------------|-------------------------------------------------------------------------------------|
| `atoum-plugin:toggle`                | Toggles atoum panel                                            | <kbd>ctrl</kbd> + <kbd>alt</kbd> + <kbd>a</kbd>                                     |
| `atoum-plugin:run-file`              | Runs the selected file in the treeview                         | 🖱                                                                                   |
| `atoum-plugin:run-current-file`      | Runs the selected directory in the treeview                    | 🖱                                                                                   |
| `atoum-plugin:run-directory`         | Runs the currently focused file in the editor                  | <kbd>cmd</kbd> + <kbd>ctrl</kbd> + <kbd>alt</kbd> + <kbd>a</kbd>                    |
| `atoum-plugin:run-current-directory` | Runs the directory of the currently focused file in the editor | <kbd>cmd</kbd> + <kbd>shift</kbd> + <kbd>ctrl</kbd> + <kbd>alt</kbd> + <kbd>a</kbd> |

## Configuration

| Key                                | Description                            | Default                        |
|------------------------------------|----------------------------------------|--------------------------------|
| `atoum-plugin.usePackagedPhar`     | Use the packaged [atoum PHAR](http://docs.atoum.org/en/latest/getting_started.html?highlight=phar#phar-archive)                                     | `false`                        |
| `atoum-plugin.maxChildrenNumber`   | Maximum number of [concurrent processes](http://docs.atoum.org/en/latest/option_cli.html?highlight=process#mcn-integer-max-children-number-integer) | Number of CPUs on your machine |
| `atoum-plugin.disableCodeCoverage` | Disable [code coverage](http://docs.atoum.org/en/latest/option_cli.html?highlight=process#ncc-no-code-coverage)                                     | `true`                         |
| `atoum-plugin.enableDebugMode`     | Enable [debug mode](http://docs.atoum.org/en/latest/written_help.html#le-mode-debug)                                                                | `false`                        |
| `atoum-plugin.xdebugConfig`        | xDebug configuration                                                                                                                                | ` `                            |
| `atoum-plugin.failIfVoidMethod`    | Fail if there is a void method                                                                                                                      | `false`                        |
| `atoum-plugin.failIfSkippedMethod` | Fail if there is a skipped method                                                                                                                   | `false`                        |
| `atoum-plugin.phpPath`             | Path to the PHP binary to use                                                                                                                       | `php`                          |
| `atoum-plugin.phpArguments`        | Arguments to append to the PHP command                                                                                                              | ` `                            |
