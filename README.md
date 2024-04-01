# Package2Pods
Package2Pods is a samll tool to create .podspec from SPM Package

![GitHub License](https://img.shields.io/github/license/chenhaiteng/Package2Pods)

The tool try to reduce the effort to publish a SPM-based Package to Cocoapods.
Currently, to convert SPM package to Cocoapods, it needs following steps:
1. Invoke `pod lib create` , it will create a folder that contains a basic Pods library with interactively command.
2. To make the library work, it need update some git/spm information into the {Library}.podspec manually. 
3. It need to add dependency manually.

To reduce those efforts, Pcakage2Pods read some information from the SPM package and its git repo. and convert and append those information to given template podspec.
currently, it collects and updates following information into podspec:
1. Package Name, Platforms, Swift Tool Version and dependencies from Swift Package.
2. User name, email, repo url (with the scheme "https"), and the latest tag from git.

## Usage

```console
USAGE: package-to-pods [--template <template>]

OPTIONS:
  -t, --template <template>
                          The repo or file url of the template podspec.
  -h, --help              Show help information.
```
### Workflow to create Cocoapods from SPM package

1. Create and write SPM package
2. Push the package to remote repo and release it by assign a tag.
3. In the root of the package(which should contains a Package.Swift file), execute pcakge-to-pods to create ${Package Name}.podspec
4. Open the ${Package Name}.podspec, check and update `s.summary`, `s.description`, `s.homepage`, and `s.license` if necessary.
5. Execute `pod lib lint` to check if there is any error need to be fixed. (normally, it might need update the dependency name to related pod)
6. If every thing is ok, run `pod trunk register ${user_email}` and `pod trunk push` to publish your pods.

## Installation
To install Package2Pods
1. clone the repo to local.
2. open terminal and chanage diretory to local repo.
3. run `./buildAndInstall.sh`

It will build and copy the release version into `/usr/local/bin`

## Advance Topics:
Package2Pods also allow you to create template podspec.
Yout can refer the default template [here](https://github.com/chenhaiteng/swift-package-to-cocoapods-template) to write customized one.

## License
Package2Pods is available under the MIT license. See the LICENSE file for more info.

If you think this tools is good, buy me a coffee would be helpful.
<a href="https://www.buymeacoffee.com/chenhaiteng"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=☕&slug=chenhaiteng&button_colour=FFDD00&font_colour=000000&font_family=Bree&outline_colour=000000&coffee_colour=ffffff" /></a>
