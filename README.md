Version: 0.2

# Vagrant Swiftbox (vagrant-swiftbox)

Vagrant Swiftbox is an open source [Vagrant](http://vagrantup.com) configuration focused on [Swift](http://swift.org) development.

## The Purpose of Vagrant Swiftbox

The primary goal of Vagrant Swiftbox is to provide an easy way for developer to get familiar with Swift development. It provides a consistent environment that are not bound to the restrictions of the host operating system.

## Requirements

Vagrant Swiftbox requires recent versions of both Vagrant and VirtualBox to be installed.

[Vagrant](http://www.vagrantup.com) is a "tool for building and distributing development environments". It works with [virtualization](http://en.wikipedia.org/wiki/X86_virtualization) software such as [VirtualBox](https://www.virtualbox.org/) to provide a virtual machine sandboxed from your local environment.

## Preparing your environment

To use Vagrant Swiftbox you will need to install some software first. This is what allows you to create a virtual machine on your host machine (typically, your actual computer you are working on).

1. Use any local operating system such as Mac OS X, Linux, or Windows.
1. Install [VirtualBox 4.3.x](https://www.virtualbox.org/wiki/Downloads)
1. Install [Vagrant 1.6.x](http://www.vagrantup.com/downloads.html)
    * `vagrant` will now be available as a command in your terminal, try it out.

## Getting Started (Using pre-compiled Swift binaries)
This is the easy way to start using Swift. It will download the Swift binaries and make it available on your virtual machine.
If you would like to build Swift from the source files, skip to "Advanced: Build Swift from Source"

1. Download or clone this repository to your local machine.
	* Using git: `git clone git://github.com/rheinardkorf/vagrant-swiftbox swiftbox`
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
1. Once you are done and you would like to shut down your VM, make sure you're not inside your VM `exit` and then type `vagrant halt` on your local machine.

## Optional
1. Install the [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) plugin with `vagrant plugin install vagrant-hostsupdater`
    * Note: This is not required, but will automatically setup your local hosts file to access `swiftbox`.
1. Install the [vagrant-triggers](https://github.com/emyl/vagrant-triggers) plugin (`vagrant plugin install vagrant-triggers`)
    * This is handy if you want to execute code when your virtual machine `up`s, `halts` or `reloads`.

## Advanced: Building Swift from Source
If you don't want to wait for the binaries to be updated; you want to contribute to Swift or you have a very specific reason for doing so, you can build Swift from it's source code.

1. Download or clone this repository to your local machine.
	* Using git: `git clone git://github.com/rheinardkorf/vagrant-swiftbox swiftbox`
1. In a command prompt, change into the new directory with `cd swiftbox` (or wherever you cloned/extracted the repo)
1. Start Vagrant without the default provisioning (fancy word for setup): `vagrant up --no-provision`
    * Pay attention if the script requires administrator passwords.
1. Make sure the previous command succeeded, then provision using the Swift source: `vagrant provision --provision-with source`  
    * Downloading and building from source takes a very long time 45 min plus. Go do something while you wait for the code to compile.
1. Login in for development.
    * Type in `vagrant ssh` in this project's folder to access your virtual machine (VM).
    * The Swift tools will now be available for use.
1. Access projects in the VM and on your local machine.
	* For convenience the /projects folder on your computer and the /srv/projects folder on your VM are mapped and kept in sync allowing you to access the same files in both environments.

## Advanced: How to update your source-built Swift  

1. Go to `~/swift-src/swift` and type the following two commands:  
	* `git fetch`  
	* `git pull`  
1. Update all related projects by typing:  
	* `~/swift-src/swift`
	* `./utils/update-checkout --clone`
1. Build the project and install:
	* `./utils/build-script --preset=buildbot_linux_1404 install_destdir=~/swift-build installable_package=~/swift.tar.gz`  
	* `sudo rsync -rl .~/swift-build/usr/ /usr/`  

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
