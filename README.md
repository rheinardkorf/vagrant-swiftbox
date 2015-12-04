# Vagrant Swiftbox (vagrant-swiftbox)

Vagrant Swiftbox is an open source [Vagrant](http://vagrantup.com) configuration focused on [Swift](http://swift.org) development.

## The Purpose of Vagrant Swiftbox

The primary goal of Vagrant Swiftbox is to provide an easy way for developer to get familiar with Swift development. It provides a consistent environment that are not bound to the restrictions of the host operating system.

## Requirements

Vagrant Swiftbox requires recent versions of both Vagrant and VirtualBox to be installed.

[Vagrant](http://www.vagrantup.com) is a "tool for building and distributing development environments". It works with [virtualization](http://en.wikipedia.org/wiki/X86_virtualization) software such as [VirtualBox](https://www.virtualbox.org/) to provide a virtual machine sandboxed from your local environment.

## Getting Started

1. Download or clone this repository to your local machine.
	* Using git: `git clone git://github.com/rheinardkorf/vagrant-swiftbox swiftbox`
1. Use any local operating system such as Mac OS X, Linux, or Windows.
1. Install [VirtualBox 4.3.x](https://www.virtualbox.org/wiki/Downloads)
1. Install [Vagrant 1.6.x](http://www.vagrantup.com/downloads.html)
    * `vagrant` will now be available as a command in your terminal, try it out.
1. Install the [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) plugin with `vagrant plugin install vagrant-hostsupdater`
    * Note: This is not required, but will automatically setup your local hosts file to access `swiftbox`.
1. Optionally use [vagrant-triggers](https://github.com/emyl/vagrant-triggers) plugin (`vagrant plugin install vagrant-triggers`)
    * This is handy if you want to execute code when your virtual machine `up`s, `halts` or `reloads`.
1. In a command prompt, change into the new directory with `cd swiftbox` (or wherever you cloned/extracted the repo)
1. Start the Vagrant environment with `vagrant up`
    * The initial setup takes some time. If you want to save time on future boxes, consider using the vagrant-cachier plugin.
    * Pay attention if the script requires administrator passwords.
1. Login in for development.
    * Type in `vagrant ssh` in this project's folder to access your virtual machine (VM).
    * When logged in, type in `swift` to use the Swift REPL and get started immediately.
    * See [Using the Swift REPL](https://swift.org/getting-started/#using-the-repl) documentation.
1. Access projects in the VM and on your local machine.
	* For convenience the /projects folder on your computer and the /srv/projects folder on your VM are mapped and kept in sync allowing you to access the same files in both environments.

## License

This program is free software; you can redistribute it and/or
modify it under the terms of the [GNU General Public License](http://www.gnu.org/licenses/gpl-2.0.html)
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

Get a copy of this license here: [GNU General Public License](http://www.gnu.org/licenses/gpl-2.0.html)
